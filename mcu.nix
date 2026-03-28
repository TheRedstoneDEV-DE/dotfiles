{
  # UDEV-rules for various MCUs
  users.groups.plugdev = {};

  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0369", OWNER="robert", GROUP="plugdev",MODE="0666"
  SUBSYSTEM=="usb", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0069", OWNER="robert", GROUP="plugdev", TAG+="uaccess", MODE="0666"
  SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE="0666"

  # Teensy
  ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789]?", ENV{ID_MM_DEVICE_IGNORE}="1"
  ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789]?", ENV{MTP_NO_PROBE}="1"
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789]?", MODE:="0666"
  KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789]?", MODE:="0666"

  # rpi-pico (picotool)
  SUBSYSTEM=="usb", \
    ATTRS{idVendor}=="2e8a", \
    ATTRS{idProduct}=="0003", \
    TAG+="uaccess", \
    MODE="660", \
    GROUP="plugdev"
  SUBSYSTEM=="usb", \
    ATTRS{idVendor}=="2e8a", \
    ATTRS{idProduct}=="0009", \
    TAG+="uaccess", \
    MODE="660", \
    GROUP="plugdev"
  SUBSYSTEM=="usb", \
    ATTRS{idVendor}=="2e8a", \
    ATTRS{idProduct}=="000a", \
    TAG+="uaccess", \
    MODE="660", \
    GROUP="plugdev"
  SUBSYSTEM=="usb", \
    ATTRS{idVendor}=="2e8a", \
    ATTRS{idProduct}=="000f", \
    TAG+="uaccess", \
    MODE="660", \
    GROUP="plugdev"
  '';

}
