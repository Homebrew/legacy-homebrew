module OS
  module Mac
    def xcode_folder
      Xcode.folder
    end

    def xcode_prefix
      Xcode.prefix
    end

    def xcode_installed?
      Xcode.installed?
    end

    def xcode_version
      Xcode.version
    end

    def clt_installed?
      CLT.installed?
    end

    def clt_version?
      CLT.version
    end

    def x11_installed?
      X11.installed?
    end

    def x11_prefix
      X11.prefix
    end

    def leopard?
      version == "10.5"
    end

    def snow_leopard?
      version >= "10.6"
    end
    alias_method :snow_leopard_or_newer?, :snow_leopard?

    def lion?
      version >= "10.7"
    end
    alias_method :lion_or_newer?, :lion?

    def mountain_lion?
      version >= "10.8"
    end
    alias_method :mountain_lion_or_newer?, :mountain_lion?

    def macports_or_fink_installed?
      !macports_or_fink.empty?
    end
  end
end
