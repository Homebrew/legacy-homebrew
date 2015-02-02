require "requirement"

class AprDependency < Requirement
  fatal true
  default_formula "apr-util"

  satisfy { MacOS::CLT.installed? || Formula["apr"].installed? }

  env do
    unless MacOS::CLT.installed?
      ENV.prepend_path "PATH", Formula["apr-util"].opt_bin
      ENV.prepend_path "PATH", Formula["apr"].opt_bin
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["apr"].opt_libexec}/lib/pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["apr-util"].opt_libexec}/lib/pkgconfig"
    end
  end
end
