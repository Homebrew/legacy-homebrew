class Caveats
  def self.print f
    s = []

    unless f.caveats.to_s.strip.empty?
      s << f.caveats
    end

    keg = Keg.new(f.prefix) rescue nil
    keg ||= Keg.new(f.opt_prefix.realpath) rescue nil
    keg ||= Keg.new(f.linked_keg.realpath) rescue nil

    if keg and keg.completion_installed? :bash
      s << "\n" unless s.empty?
      s << <<-EOS.undent
        Bash completion has been installed to:
          #{HOMEBREW_PREFIX}/etc/bash_completion.d
        EOS
    end

    if keg and keg.completion_installed? :zsh
      s << "\n" unless s.empty?
      s <<  <<-EOS.undent
        zsh completion has been installed to:
          #{HOMEBREW_PREFIX}/share/zsh/site-functions
        EOS
    end

    if f.plist or (keg and keg.plist_installed?)
      s << "\n" unless s.empty?

      destination = f.plist_startup ? '/Library/LaunchDaemons' \
                                    : '~/Library/LaunchAgents'

      plist_filename = f.plist_path.basename
      plist_link = "#{destination}/#{plist_filename}"
      plist_domain = f.plist_path.basename('.plist')
      destination_path = Pathname.new File.expand_path destination
      plist_path = destination_path/plist_filename

      # we readlink because this path probably doesn't exist since caveats
      # occurs before the link step of installation
      if (not plist_path.file?) and (not plist_path.symlink?)
        if f.plist_startup
          s << "To have launchd start #{f.name} at startup:"
          s << "    sudo mkdir -p #{destination}" unless destination_path.directory?
          s << "    sudo cp -fv #{HOMEBREW_PREFIX}/opt/#{f.name}/*.plist #{destination}"
        else
          s << "To have launchd start #{f.name} at login:"
          s << "    mkdir -p #{destination}" unless destination_path.directory?
          s << "    ln -sfv #{HOMEBREW_PREFIX}/opt/#{f.name}/*.plist #{destination}"
        end
        s << "Then to load #{f.name} now:"
        if f.plist_startup
          s << "    sudo launchctl load #{plist_link}"
        else
          s << "    launchctl load #{plist_link}"
        end
        if f.plist_manual
          s << "Or, if you don't want/need launchctl, you can just run:"
          s << "    #{f.plist_manual}"
        end
      elsif Kernel.system "/bin/launchctl list #{plist_domain} &>/dev/null"
        s << "You should reload #{f.name}:"
        if f.plist_startup
          s << "    sudo launchctl unload #{plist_link}"
          s << "    sudo cp -fv #{HOMEBREW_PREFIX}/opt/#{f.name}/*.plist #{destination}"
          s << "    sudo launchctl load #{plist_link}"
        else
          s << "    launchctl unload #{plist_link}"
          s << "    launchctl load #{plist_link}"
        end
      else
        s << "To load #{f.name}:"
        if f.plist_startup
          s << "    sudo launchctl load #{plist_link}"
        else
          s << "    launchctl load #{plist_link}"
        end
      end
    end

    ohai 'Caveats', s unless s.empty?
  end
end
