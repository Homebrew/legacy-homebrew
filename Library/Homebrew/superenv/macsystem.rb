# new code because I don't really trust the Xcode code now having researched it more
module MacSystem extend self
  def xcode_clt_installed?
    # TODO: handle 10.9 CLT which has headers under:
    # /Library/Developer/CommandLineTools/usr/include
    File.executable? "/usr/bin/clang" and File.executable? "/usr/bin/lldb" and
      File.executable? "/usr/bin/make" and File.directory? "/usr/include"
  end

  def xcode43_without_clt?
    MacOS::Xcode.version >= "4.3" and not MacSystem.xcode_clt_installed?
  end

  def x11_prefix
    @x11_prefix ||= %W[/opt/X11 /usr/X11
      #{MacOS.sdk_path}/usr/X11].find{|path| File.directory? "#{path}/include" }
  end
end
