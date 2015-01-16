require "requirement"

class AprDependency < Requirement
  fatal true
  default_formula "apr"

  satisfy { MacOS::CLT.installed? || Formula["apr"].installed? }

  env do
    unless MacOS::CLT.installed?
      ENV.prepend_path "PATH", "#{Formula["apr-util"].opt_prefix}/bin"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["apr"].opt_prefix}/libexec/lib/pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["apr-util"].opt_prefix}/libexec/lib/pkgconfig"
    end
  end

  def message
    message = <<-EOS.undent
      Due to packaging problems on Apple's part, software that compiles
      against APR requires the standalone Command Line Tools.
    EOS
    if MacOS.version >= :mavericks
      message += <<-EOS.undent
        Either
        `brew install apr-util`
        or
        `xcode-select --install`
        to install APR.
      EOS
    else
      message += <<-EOS.undent
        The standalone package can be obtained from
        https://developer.apple.com/downloads/,
        or it can be installed via Xcode's preferences.
        Or you can `brew install apr-util`.
      EOS
    end
  end
end
