module Homebrew
  class SystemCommand

    def self.platform
      if RUBY_PLATFORM =~ /.*-linux/
        :linux
      elsif RUBY_PLATFORM =~ /.*-darwin.*/
        :mac
      elsif RUBY_PLATFORM =~ /.*-freebsd.*/
        :freebsd
      else
        :dunno
      end
    end

    def self.arch
      `#{uname} -m`.strip.chomp
    end

    def self.provider
      uname = ''
      if File.exist? '/bin/uname'
        uname = '/bin/uname'
      else
        uname = '/usr/bin/uname'
      end
      case `#{uname}`.strip.chomp
      when 'Linux'
        @@provider ||= SystemCommandLinux.new
      when 'Darwin'
        @@provider ||= SystemCommandMac.new
      when 'FreeBSD'
        @@provider ||= SystemCommandFreeBSD.new
      else
        raise Exception.new 'Unknown platform. Aborting.'
      end
    end

    def self.method_missing(name, *args, &block)
      %w{/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin}.each do |p|
        return p + "/#{name}" if File.exist?(p + "/#{name}")
      end
      Class.method_missing(name, *args, &block)
    end

    def self.which_s
      provider.which_s
    end

    # du human readable output with default depth 0
    # du -hd0 MacOX
    # du -h --max-depth 0 Linux
    def self.du_h_depth(depth=0)
      provider.du_h_depth
    end

    def self.ruby
      `#{SystemCommand.which_s} ruby`.chomp
    end
  end

  class SystemCommandLinux

    def which_s
      '/usr/bin/which'
    end

    # du human readable output with default depth 0
    # du -hd0 MacOX
    # du -h --max-depth 0 Linux
    def du_h_depth(depth=0)
      "/usr/bin/du -h --max-depth #{depth}"
    end
  end

  class SystemCommandMac
    def which_s
      '/usr/bin/which -s'
    end
    
    def du_h_depth(depth=0)
      "/usr/bin/du -hd#{depth}"
    end

  end

   class SystemCommandFreeBSD < SystemCommandMac

     def which_s
       "/usr/bin/which"
     end
   end
end
