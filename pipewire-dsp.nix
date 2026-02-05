{ pkgs, ... }:
{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraScripts =  {
      "link-nodes.lua" = ''
        -- Auto-link music monitor to music_processor.in when both appear
        om = ObjectManager {
          Interest {
            -- Match output ports from music node
            type = "port",
            Constraint { "port.alias", "matches", "music:monitor_*" },
          },
          Interest {
            type = "port",
            Constraint { "port.alias", "matches", "the-voices-in-my-head:monitor_*" },
          },
          Interest {
            type = "port",
            Constraint { "port.alias", "matches", "LSP Music Sidechain Sink:playback_*" },
          },
          Interest {
            type = "port",
            Constraint { "port.alias", "matches", "LSP Surround Correction*" },
          },
          Interest {
            type = "port",
            Constraint { "port.alias", "matches", "PipeWire RTP stream:send_*" },
          },
          Interest {
            type = "port",
            Constraint { "port.alias", "matches", "Scarlett 4i4 USB:*" },
          },
          Interest {
            type = "port",
            Constraint { "port.alias", "matches", "LSP Voice Processor:input_MONO" }
          }
        }
        
        
        
        local links_created = {}
        
        local function try_link()
          local pairs = {
            { out = "music:monitor_FL", in_port = "LSP Music Sidechain Sink:playback_FL" },
            { out = "music:monitor_FR", in_port = "LSP Music Sidechain Sink:playback_FR" },
        
            { out = "the-voices-in-my-head:monitor_FL", in_port = "LSP Music Sidechain Sink:playback_RL" },
            { out = "the-voices-in-my-head:monitor_FR", in_port = "LSP Music Sidechain Sink:playback_RR" },
        
            { out = "Scarlett 4i4 USB:monitor_RL", in_port = "LSP Surround Correction:playback_FL" },
            { out = "Scarlett 4i4 USB:monitor_RR", in_port = "LSP Surround Correction:playback_FR" },
        
            { out = "LSP Surround Correction:capture_FL", in_port = "PipeWire RTP stream:send_FL" },
            { out = "LSP Surround Correction:capture_FR", in_port = "PipeWire RTP stream:send_FR" },
        
            { out = "Scarlett 4i4 USB:capture_FL", in_port = "LSP Voice Processor:input_MONO" }

          }
        
          for _, p in ipairs(pairs) do
            if not links_created[p.out] then
              local out_port = om:lookup {
                Constraint { "port.alias", "equals", p.out }
              }
              local in_port = om:lookup {
                Constraint { "port.alias", "equals", p.in_port }
              }
        
              if out_port and in_port then
                local link = Link("link-factory", {
                  ["link.output.node"] = out_port.properties["node.id"],
                  ["link.output.port"] = out_port.properties["object.id"],
                  ["link.input.node"] = in_port.properties["node.id"],
                  ["link.input.port"] = in_port.properties["object.id"],
                  ["object.linger"] = true,
                  ["link.passive"] = true,
                })
                link:activate(1)
                links_created[p.out] = true
                print("Linked " .. p.out .. " -> " .. p.in_port)
              end
            end
          end
        end
        
        om:connect("object-added", try_link)
        om:activate()
      '';
    };

    wireplumber.extraConfig."99-link-script" = {
      "wireplumber.components" = [
        {
          name = "link-nodes.lua";
          type = "script/lua";
          provides = "nodes.linker";
        }
      ];
      "wireplumber.profiles" = {
        main = {
          "nodes.linker" = "required";
        };
      };
    };

    jack.enable = true;
    extraLv2Packages = [ pkgs.lsp-plugins ];
    extraConfig.pipewire."10-rtp" = {
      "context.modules" = [
        {
          name = "libpipewire-module-rtp-source";
          args = {
            "source.ip" = "0.0.0.0";
            "source.port" = 10001;
            "sess.latency.msec" = 0;
            "sess.ignore-ssrc" = true;
            "stream.props" = {
              "media.class" = "Audio/Source";
              "node.name" = "external_in";
            };
          };
        }
        {
          name = "libpipewire-module-rtp-sink";
          args = {
            "destination.ip" = "192.168.0.230";
            "destination.port" = 10001;
            "sess.name" = "PipeWire RTP stream";
            "audio.rate" = 48000;
            "audio.channels" = 2;
            "audio.position" = [ "FL" "FR" ];
            "stream.props" = {
              "media.class" = "Audio/Sink";
              "node.name" = "rear-channel";
              "node.alias" = "Rear Channel";
            };
          };
        }
      ]; 
    };
    extraConfig.pipewire."11-null-audio" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "the-voices-in-my-head";
            "media.class" = "Audio/Sink";
            "object.linger" = true;
            "audio.position" = [ "FL" "FR" ];
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name" = "support.null-audio-sink";
            "node.name" = "music";
            "media.class" = "Audio/Sink";
            "object.linger" = true;
            "audio.position" = [ "FL" "FR" ];
          };
        }
      ];
    }; 
    extraConfig.pipewire."80-lsp-dsp" = { 
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "capture.props" = {
              "audio.channels" = 4;
              "audio.position" = [ "FL" "FR" "RL" "RR" ];
              "media.class" = "Audio/Sink";
              "node.name" = "music_processor.in";
            };
            "filter.graph" = {
              inputs = [
                "lsp_scomp:in_l"
                "lsp_scomp:in_r"
                "lsp_autogain:in_l"
                "lsp_autogain:in_r"
              ];
              links = [
                {
                  output = "lsp_autogain:out_l";
                  input = "lsp_scomp:sc_l";
                }
                {
                  output = "lsp_autogain:out_r";
                  input = "lsp_scomp:sc_r";
                }
                {
                  output = "lsp_autogain:out_r";
                  input = "mix_right:In 1";
                }
                {
                  output = "lsp_autogain:out_l";
                  input = "mix_left:In 1";
                }
                {
                  output = "lsp_scomp:out_r";
                # input = "cpy_right:In";
                  input = "mix_right:In 2";

                }
                {
                  output = "lsp_scomp:out_l";
                # input = "cpy_left:In";
                  input = "mix_left:In 2";
                }
                {
                  output = "lsp_scomp:out_r";
                  input = "cpy_right:In";
                }
                {
                  output = "lsp_scomp:out_l";
                  input = "cpy_left:In";
                }
              ];
              nodes = [
                {
                  control = {
                    level = -38;
                  };
                  config = {};
                  name = "lsp_autogain";
                  plugin = "http://lsp-plug.in/plugins/lv2/autogain_stereo";
                  type = "lv2";
                }
                {
                  control = {
                    sct = 2;
                    scm = 1;
                    scs = 0;
                    scr = 7.81;
                    scp = 8.9;
                    al  = 0.0398107;
                    scl = 0;
                    cdw = 100.0;
                    enabled = 1;
                  };
                  config = {};
                  name = "lsp_scomp";
                  plugin = "http://lsp-plug.in/plugins/lv2/sc_compressor_stereo";
                  type = "lv2";
                }
                {
                  type = "builtin";
                  name = "mix_left";
                  label = "mixer";
                  control = {
                    "Gain 1" = 0.8;
                    "Gain 2" = 0.8;
                  };
                }
                {
                  type = "builtin";
                  name = "mix_right";
                  label = "mixer";
                  control = {
                    "Gain 1" = 0.8;
                    "Gain 2" = 0.8;
                  };
                }
                {
                  type = "builtin";
                  name = "cpy_right";
                  label = "copy";
                }
                {
                  type = "builtin";
                  name = "cpy_left";
                  label = "copy";
                }
              ];
              outputs = [
                "mix_left:Out"
                "mix_right:Out"
                "cpy_left:Out"
                "cpy_right:Out"
              ];
            };
            "media.name" = "LSP Processed Sink";
            "node.description" = "LSP Music Sidechain Sink";
            "playback.props" = {
              "node.target" = "alsa_output.usb-Focusrite_Scarlett_4i4_USB_D8Y6D6D242800D-00.analog-surround-40";
              #"node.channels" = 4;
              #"node.position" = ["FL" "FR" "RL" "RR"];
              #"node.autoconnect" = true;
            };
          };
        }
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "LSP Surround Correction";
            "media.name" = "LSP Surround Correction";
            "filter.graph" = {
              "nodes" = [ 
                {
                  type = "lv2";
                  name = "lsp_eq";
                  plugin = "http://lsp-plug.in/plugins/lv2/para_equalizer_x8_lr";
                  control = {
                    bal = -8.0;

                    # -- Filter 0 - Left --
                    ftl_0  = 5;         # -> Type: Lo-shelf
                    fml_0  = 5;         # -> Mode: LRX (MT)
                    sl_0   = 0;         # -> Filter Slope: x1
                    xsl_0  = 0;     # -> Filter [S]
                    xml_0  = 0;     # -> Filter [M]
                    fl_0   = 298.00;    # -> Frequency
                    wl_0   = 1.36;      # -> Width
                    gl_0   = 1.75;      # -> Gain
                    ql_0   = 0.75;      # -> [Q]uality factor
                    huel_0 = 0.0;       # -> Hue

                    # -- Filter 0 - Right --
                    ftr_0  = 5;         # -> Type: Lo-shelf
                    fmr_0  = 5;         # -> Mode: LRX (MT)
                    sr_0   = 0;         # -> Filter Slope: x1
                    xsr_0  = 0;     # -> Filter [S]
                    xmr_0  = 0;     # -> Filter [M]
                    fr_0   = 298.00;    # -> Frequency
                    wr_0   = 4.00;      # -> Width
                    gr_0   = 1.85;      # -> Gain
                    qr_0   = 0.00;      # -> [Q]uality factor
                    huer_0 = 0.0;       # -> Hue

                    # -- Filter 1 - Left --
                    ftl_1  = 3;         # -> Type: High-shelf
                    fml_1  = 5;         # -> Mode: LRX (MT)
                    sl_1   = 0;         # -> Filter Slope: x1
                    xsl_1  = 0;     # -> Filter [S]
                    xml_1  = 0;     # -> Filter [M]
                    fl_1   = 2932.8;    # -> Frequency
                    wl_1   = 3.86;      # -> Width
                    gl_1   = 1.42;      # -> Gain
                    ql_1   = 0.00;      # -> [Q]uality factor
                    huel_1 = 0.0;       # -> Hue

                    # -- Filter 1 - Right --
                    ftr_1  = 1;         # -> Type: Bell
                    fmr_1  = 0;         # -> Mode: RLC (BT)
                    sr_1   = 0;         # -> Filter Slope: x1
                    xsr_1  = 0;     # -> Filter [S]
                    xmr_1  = 0;     # -> Filter [M]
                    fr_1   = 79.70;     # -> Frequency
                    wr_1   = 4.00;      # -> Width
                    gr_1   = 1.36;      # -> Gain
                    qr_1   = 2.00;      # -> [Q]uality factor
                    huer_1 = 0.0;       # -> Hue

                    # -- Filter 2 (4) - Left --
                    ftl_2  = 1;         # -> Type: Bell
                    fml_2  = 0;         # -> Mode: RLC (BT)
                    sl_2   = 0;         # -> Filter Slope: x1
                    xsl_2  = 0;     # -> Filter [S]
                    xml_2  = 0;     # -> Filter [M]
                    fl_2   = 412.9;     # -> Frequency
                    wl_2   = 4.00;      # -> Width
                    gl_2   = 1.93;      # -> Gain
                    ql_2   = 2.50;      # -> [Q]uality factor
                    huel_2 = 0.25;      # -> Hue

                    # -- Filter 2 (3) - Right --
                    ftr_2  = 3;         # -> Type: High-shelf
                    fmr_2  = 4;         # -> Mode: LRX (BT)
                    sr_2   = 0;         # -> Filter Slope: x1
                    xsr_2  = 0;     # -> Filter [S]
                    xmr_2  = 0;     # -> Filter [M]
                    fr_2   = 2980.9;    # -> Frequency
                    wr_2   = 4.00;      # -> Width
                    gr_2   = 1.39;      # -> Gain
                    qr_2   = 0.00;      # -> [Q]uality factor
                    huer_2 = 0.125;     # -> Hue

                    # -- Filter 3 (5) - Left --
                    ftl_3  = 1;         # -> Type: Bell
                    fml_3  = 0;         # -> Mode: RLC (BT)
                    sl_3   = 0;         # -> Filter Slope: x1
                    xsl_3  = 0;     # -> Filter [S]
                    xml_3  = 0;     # -> Filter [M]
                    fl_3   = 2869.4;    # -> Frequency
                    wl_3   = 4.00;      # -> Width
                    gl_3   = 0.91;     # -> Gain
                    ql_3   = 1.75;      # -> [Q]uality factor
                    huel_3 = 0.31;      # -> Hue

                    # -- Filter 3 (4) - Right --
                    ftr_3  = 1;         # -> Type: Bell
                    fmr_3  = 0;         # -> Mode: RLC (BT)
                    sr_3   = 0;         # -> Filter Slope: x1
                    xsr_3  = 0;     # -> Filter [S]
                    xmr_3  = 0;     # -> Filter [M]
                    fr_3   = 410.6;     # -> Frequency
                    wr_3   = 4.00;      # -> Width
                    gr_3   = 1.86;      # -> Gain
                    qr_3   = 2.75;      # -> [Q]uality factor
                    huer_3 = 0.25;      # -> Hue

                    # -- Filter 4 - Left --
                    ftl_4  = 1;         # -> Type: Bell
                    fml_4  = 0;         # -> Mode: RLC (BT)
                    sl_4   = 0;         # -> Filter Slope: x1
                    xsl_4  = 0;     # -> Filter [S]
                    xml_4  = 1;     # -> Filter [M]
                    fl_4   = 410.6;     # -> Frequency
                    wl_4   = 4.00;      # -> Width
                    gl_4   = 1.86;      # -> Gain
                    ql_4   = 2.75;      # -> [Q]uality factor
                    huel_4 = 0.25;      # -> Hue

                    # -- Filter 4 (5) - Right --
                    ftr_4  = 1;         # -> Type: Bell
                    fmr_4  = 0;         # -> Mode: RLC (BT)
                    sr_4   = 0;         # -> Filter Slope: x1
                    xsr_4  = 0;     # -> Filter [S]
                    xmr_4  = 0;     # -> Filter [M]
                    fr_4   = 2828.2;    # -> Frequency
                    wr_4   = 4.00;      # -> Width
                    gr_4   = 0.91;     # -> Gain
                    qr_4   = 2.00;      # -> [Q]uality factor
                    huer_4 = 0.31;      # -> Hue
                  };
                }
              ];
              "links" = [ 
              ];
              "inputs" = ["lsp_eq:in_l" "lsp_eq:in_r"];
              "outputs" = ["lsp_eq:out_l" "lsp_eq:out_r"];
            };
            "capture.props" = {
              "node.name" = "surround_corrector.in";
              "media.class" = "Audio/Sink";
              "audio.channels" = 2;
              "audio.position" = [ "FL" "FR" ];
              "node.autoconnect" = true;
            };
            "playback.props" = {
              "node.name" = "surround_corrector.out";
              "media.class" = "Audio/Source";
              "node.passive" = true;
              "audio.channels" = 2;
              "audio.position" = [ "FL" "FR" ];
              "node.autoconnect" = true;
            };
          };
        }
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "capture.props" = {
              "node.target" = "alsa_input.usb-Focusrite_Scarlett_4i4_USB_D8Y6D6D242800D-00.analog-surround-51:capture_FL";
              "node.autoconnect" = false;
            };
            "filter.graph" = {
              inputs = [
                "lsp_gate:in"
              ];
              links = [
                {
                  output = "lsp_gate:out";
                  input = "lsp_autogain:in";
                }
              ];
              nodes = [
                {
                  control = {
                    gh   = 1;
                    gr   = 0.00025;
                    gt   = 0.0276;
                    gz   = 0.7405;
                    ht   = 0.1096;
                    hz   = 0.7404;
                    hold = 500;
                  };
                  config = {};
                  name = "lsp_gate";
                  plugin = "http://lsp-plug.in/plugins/lv2/gate_mono";
                  type = "lv2";
                }
                {
                  control = {};
                  config = {};
                  name = "lsp_autogain";
                  plugin = "http://lsp-plug.in/plugins/lv2/autogain_mono";
                  type = "lv2";
                }
              ];
              outputs = [
                "lsp_autogain:out"
              ];
            };
            "media.name" = "LSP Voice Processor";
            "node.description" = "LSP Voice Processor";
            "playback.props" = {
              "audio.channels" = 1;
              "audio.position" = [ "MONO" ];
              "media.class" = "Audio/Source";
              "node.name" = "mic_processor.out";
              "node.passive" = true;
            };
          };
        }
      ];
    };
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
}
