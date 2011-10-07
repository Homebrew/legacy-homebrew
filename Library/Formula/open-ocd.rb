require 'formula'

class OpenOcd < Formula
  url 'http://download.berlios.de/openocd/openocd-0.5.0.tar.bz2'
  homepage 'http://openocd.berlios.de/web/'
  md5 '43434c2b5353c9b853278b8bff22cb1a'

  depends_on 'libusb-compat'

  if ARGV.include?('--enable-ft2232_libftdi') || ARGV.include?('--enable-presto_libftdi')
    depends_on 'libftdi'
  end

  def options
    [
      ['--enable-dummy',              'Enable building the dummy JTAG port driver'                             ],
      ['--enable-ft2232_libftdi',     'Enable building support for FT2232 based devices with libftdi driver'   ],
      ['--enable-ft2232_ftd2xx',      'Enable building support for FT2232 based devices with FTD2XX driver'    ],
      ['--enable-gw16012',            'Enable building support for Gateworks GW16012 JTAG Programmer'          ],
      ['--enable-parport',            'Enable building the pc parallel port driver'                            ],
      ['--disable-parport-ppdev',     'Disable use of ppdev (/dev/parportN) for parport (for x86 only)'        ],
      ['--enable-parport-giveio',     'Enable use of giveio for parport (for CygWin only)'                     ],
      ['--enable-presto_libftdi',     'Enable building support for ASIX Presto Programmer with libftdi driver' ],
      ['--enable-presto_ftd2xx',      'Enable building support for ASIX Presto Programmer with FTD2XX driver'  ],
      ['--enable-amtjtagaccel',       'Enable building the Amontec JTAG-Accelerator driver'                    ],
      ['--enable-arm-jtag-ew',        'Enable building support for the Olimex ARM-JTAG-EW Programmer'          ],
      ['--enable-jlink',              'Enable building support for the Segger J-Link JTAG Programmer'          ],
      ['--enable-rlink',              'Enable building support for the Raisonance RLink JTAG Programmer'       ],
      ['--enable-usbprog',            'Enable building support for the usbprog JTAG Programmer'                ],
      ['--enable-vsllink',            'Enable building support for the Versaloon-Link JTAG Programmer'         ],
      ['--enable-oocd_trace',         'Enable building support for the OpenOCD+trace ETM capture device'       ],
      ['--enable-ep93xx',             'Enable building support for EP93xx based SBCs'                          ],
      ['--enable-at91rm9200',         'Enable building support for AT91RM9200 based SBCs'                      ],
      ['--enable-ecosboard',          'Enable building support for eCos based JTAG debugger'                   ],
      ['--enable-zy1000',             'Enable ZY1000 interface'                                                ],
      ['--enable-minidriver-dummy',   'Enable the dummy minidriver'                                            ],
      ['--enable-ioutil',             'Enable ioutil functions - useful for standalone OpenOCD implementations'],
      ['--disable-doxygen-html',      'Disable building Doxygen manual as HTML'                                ],
      ['--enable-doxygen-pdf',        'Enable building Doxygen manual as PDF'                                  ],
      ['--disable-assert',            'turn off assertions'                                                    ],
      ['--enable-verbose',            'Enable verbose JTAG I/O messages (for debugging)'                       ],
      ['--enable-verbose-jtag-io',    'Enable verbose JTAG I/O messages (for debugging)'                       ],
      ['--enable-verbose-usb-io',     'Enable verbose USB I/O messages (for debugging)'                        ],
      ['--enable-verbose-usb-comms',  'Enable verbose USB communication messages (for debugging)'              ],
      ['--enable-malloc-logging',     'Include free space in logging messages (requires malloc.h)'             ],
      ['--disable-gccwarnings',       'Disable extra gcc warnings during build'                                ],
      ['--disable-wextra',            'Disable extra compiler warnings'                                        ],
      ['--disable-werror',            'Do not treat warnings as errors'                                        ]
    ]
  end

  def install
    args = ['--enable-maintainer-mode', "--prefix=#{prefix}"]
    args << '--enable-dummy'              if ARGV.include? '--enable-dummy'
    args << '--enable-ft2232_libftdi'     if ARGV.include? '--enable-ft2232_libftdi'
    args << '--enable-ft2232_ftd2xx'      if ARGV.include? '--enable-ft2232_ftd2xx'
    args << '--enable-gw16012'            if ARGV.include? '--enable-gw16012'
    args << '--enable-parport'            if ARGV.include? '--enable-parport'
    args << '--disable-parport-ppdev'     if ARGV.include? '--disable-parport-ppdev'
    args << '--enable-parport-giveio'     if ARGV.include? '--enable-parport-giveio'
    args << '--enable-presto_libftdi'     if ARGV.include? '--enable-presto_libftdi'
    args << '--enable-presto_ftd2xx'      if ARGV.include? '--enable-presto_ftd2xx'
    args << '--enable-amtjtagaccel'       if ARGV.include? '--enable-amtjtagaccel'
    args << '--enable-arm-jtag-ew'        if ARGV.include? '--enable-arm-jtag-ew'
    args << '--enable-jlink'              if ARGV.include? '--enable-jlink'
    args << '--enable-rlink'              if ARGV.include? '--enable-rlink'
    args << '--enable-usbprog'            if ARGV.include? '--enable-usbprog'
    args << '--enable-vsllink'            if ARGV.include? '--enable-vsllink'
    args << '--enable-oocd_trace'         if ARGV.include? '--enable-oocd_trace'
    args << '--enable-ep93xx'             if ARGV.include? '--enable-ep93xx'
    args << '--enable-at91rm9200'         if ARGV.include? '--enable-at91rm9200'
    args << '--enable-ecosboard'          if ARGV.include? '--enable-ecosboard'
    args << '--enable-zy1000'             if ARGV.include? '--enable-zy1000'
    args << '--enable-minidriver-dummy'   if ARGV.include? '--enable-minidriver-dummy'
    args << '--enable-ioutil'             if ARGV.include? '--enable-ioutil'
    args << '--disable-doxygen-html'      if ARGV.include? '--disable-doxygen-html'
    args << '--enable-doxygen-pdf'        if ARGV.include? '--enable-doxygen-pdf'
    args << '--disable-assert'            if ARGV.include? '--disable-assert'
    args << '--enable-verbose'            if ARGV.include? '--enable-verbose'
    args << '--enable-verbose-jtag-io'    if ARGV.include? '--enable-verbose-jtag-io'
    args << '--enable-verbose-usb-io'     if ARGV.include? '--enable-verbose-usb-io'
    args << '--enable-verbose-usb-comms'  if ARGV.include? '--enable-verbose-usb-comms'
    args << '--enable-malloc-logging'     if ARGV.include? '--enable-malloc-logging'
    args << '--disable-gccwarnings'       if ARGV.include? '--disable-gccwarnings'
    args << '--disable-wextra'            if ARGV.include? '--disable-wextra'
    args << '--disable-werror'            if ARGV.include? '--disable-werror'

    system './configure', *args
    # Separate steps seem to be needed
    system 'make'
    system 'make install'
  end
end
