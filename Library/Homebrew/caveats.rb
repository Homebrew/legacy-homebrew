class Caveats
  attr_reader :f

  def initialize(f)
    @f = f
  end

  def caveats
    caveats = []
    begin
      build, f.build = f.build, Tab.for_formula(f)
      s = f.caveats.to_s
      caveats << s.chomp + "\n" if s.length > 0
    ensure
      f.build = build
    end
    caveats << keg_only_text
    caveats << bash_completion_caveats
    caveats << zsh_completion_caveats
    caveats << fish_completion_caveats
    caveats << plist_caveats
    caveats << python_caveats
    caveats << app_caveats
    caveats << elisp_caveats
    caveats.compact.join("\n")
  end

  def empty?
    caveats.empty?
  end

  private

  def keg
    @keg ||= [f.prefix, f.opt_prefix, f.linked_keg].map do |d|
      Keg.new(d.resolved_path) rescue nil
    end.compact.first
  end

  def keg_only_text
    return unless f.keg_only?

    s = "This formula is keg-only, which means it was not symlinked into #{HOMEBREW_PREFIX}."
    s << "\n\n#{f.keg_only_reason}"
    if f.lib.directory? || f.include.directory?
      s <<
        <<-EOS.undent_________________________________________________________72


        Generally there are no consequences of this for you. If you build your
        own software and it requires this formula, you'll need to add to your
        build variables:

        EOS
      s << "    LDFLAGS:  -L#{f.opt_lib}\n" if f.lib.directory?
      s << "    CPPFLAGS: -I#{f.opt_include}\n" if f.include.directory?
    end
    s << "\n"
  end

  def bash_completion_caveats
    if keg && keg.completion_installed?(:bash) then <<-EOS.undent
      Bash completion has been installed to:
        #{HOMEBREW_PREFIX}/etc/bash_completion.d
      EOS
    end
  end

  def zsh_completion_caveats
    if keg && keg.completion_installed?(:zsh) then <<-EOS.undent
      zsh completion has been installed to:
        #{HOMEBREW_PREFIX}/share/zsh/site-functions
      EOS
    end
  end

  def fish_completion_caveats
    if keg && keg.completion_installed?(:fish) && which("fish") then <<-EOS.undent
      fish completion has been installed to:
        #{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      EOS
    end
  end

  def python_caveats
    return unless keg
    return unless keg.python_site_packages_installed?

    s = nil
    homebrew_site_packages = Language::Python.homebrew_site_packages
    user_site_packages = Language::Python.user_site_packages "python"
    pth_file = user_site_packages/"homebrew.pth"
    instructions = <<-EOS.undent.gsub(/^/, "  ")
      mkdir -p #{user_site_packages}
      echo 'import site; site.addsitedir("#{homebrew_site_packages}")' >> #{pth_file}
    EOS

    if f.keg_only?
      keg_site_packages = f.opt_prefix/"lib/python2.7/site-packages"
      unless Language::Python.in_sys_path?("python", keg_site_packages)
        s = <<-EOS.undent
          If you need Python to find bindings for this keg-only formula, run:
            echo #{keg_site_packages} >> #{homebrew_site_packages/f.name}.pth
        EOS
        s += instructions unless Language::Python.reads_brewed_pth_files?("python")
      end
      return s
    end

    return if Language::Python.reads_brewed_pth_files?("python")

    if !Language::Python.in_sys_path?("python", homebrew_site_packages)
      s = <<-EOS.undent
        Python modules have been installed and Homebrew's site-packages is not
        in your Python sys.path, so you will not be able to import the modules
        this formula installed. If you plan to develop with these modules,
        please run:
      EOS
      s += instructions
    elsif keg.python_pth_files_installed?
      s = <<-EOS.undent
        This formula installed .pth files to Homebrew's site-packages and your
        Python isn't configured to process them, so you will not be able to
        import the modules this formula installed. If you plan to develop
        with these modules, please run:
      EOS
      s += instructions
    end
    s
  end

  def app_caveats
    if keg && keg.app_installed?
      <<-EOS.undent
        .app bundles were installed.
        Run `brew linkapps #{keg.name}` to symlink these to /Applications.
      EOS
    end
  end

  def elisp_caveats
    return if f.keg_only?
    if keg && keg.elisp_installed?
      <<-EOS.undent
        Emacs Lisp files have been installed to:
          #{HOMEBREW_PREFIX}/share/emacs/site-lisp/#{f.name}
      EOS
    end
  end

  def plist_caveats
    s = []
    if f.plist || (keg && keg.plist_installed?)
      destination = if f.plist_startup
        "/Library/LaunchDaemons"
      else
        "~/Library/LaunchAgents"
      end

      plist_filename = if f.plist
        f.plist_path.basename
      else
        File.basename Dir["#{keg}/*.plist"].first
      end
      plist_link = "#{destination}/#{plist_filename}"
      plist_domain = f.plist_path.basename(".plist")
      destination_path = Pathname.new File.expand_path destination
      plist_path = destination_path/plist_filename

      # we readlink because this path probably doesn't exist since caveats
      # occurs before the link step of installation
      # Yosemite security measures mildly tighter rules:
      # https://github.com/Homebrew/homebrew/issues/33815
      if !plist_path.file? || !plist_path.symlink?
        if f.plist_startup
          s << "To have launchd start #{f.full_name} at startup:"
          s << "  sudo mkdir -p #{destination}" unless destination_path.directory?
          s << "  sudo cp -fv #{f.opt_prefix}/*.plist #{destination}"
          s << "  sudo chown root #{plist_link}"
        else
          s << "To have launchd start #{f.full_name} at login:"
          s << "  mkdir -p #{destination}" unless destination_path.directory?
          s << "  ln -sfv #{f.opt_prefix}/*.plist #{destination}"
        end
        s << "Then to load #{f.full_name} now:"
        if f.plist_startup
          s << "  sudo launchctl load #{plist_link}"
        else
          s << "  launchctl load #{plist_link}"
        end
      # For startup plists, we cannot tell whether it's running on launchd,
      # as it requires for `sudo launchctl list` to get real result.
      elsif f.plist_startup
        s << "To reload #{f.full_name} after an upgrade:"
        s << "  sudo launchctl unload #{plist_link}"
        s << "  sudo cp -fv #{f.opt_prefix}/*.plist #{destination}"
        s << "  sudo chown root #{plist_link}"
        s << "  sudo launchctl load #{plist_link}"
      elsif Kernel.system "/bin/launchctl list #{plist_domain} &>/dev/null"
        s << "To reload #{f.full_name} after an upgrade:"
        s << "  launchctl unload #{plist_link}"
        s << "  launchctl load #{plist_link}"
      else
        s << "To load #{f.full_name}:"
        s << "  launchctl load #{plist_link}"
      end

      if f.plist_manual
        s << "Or, if you don't want/need launchctl, you can just run:"
        s << "  #{f.plist_manual}"
      end

      s << "" << "WARNING: launchctl will fail when run under tmux." if ENV["TMUX"]
    end
    s.join("\n") unless s.empty?
  end
end
