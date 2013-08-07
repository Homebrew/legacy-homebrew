module MacSystem
  extend self

  def xcode_clt_installed?
    MacOS::CLT.installed?
  end

  def xcode43_without_clt?
    MacOS::Xcode.version >= "4.3" and not MacSystem.xcode_clt_installed?
  end

  def x11_prefix
    MacOS::X11.prefix
  end
end
