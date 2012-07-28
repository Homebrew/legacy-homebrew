require 'download_strategy'
require 'dependencies'
require 'formula_support'
require 'hardware'
require 'bottles'
require 'extend/fileutils'
require 'patches'
require 'compilers'


class Formula
  include FileUtils

  attr_reader :name, :path, :homepage, :downloader
  attr_reader :stable, :bottle, :devel, :head, :active_spec

  # The build folder, usually in /tmp.
  # Will only be non-nil during the stage method.
  attr_reader :buildpath

  # Homebrew determines the name
  def initialize name='__UNKNOWN__', path=nil
    set_instance_variable :homepage
    set_instance_variable :stable
    set_instance_variable :bottle
    set_instance_variable :devel
    set_instance_variable :head

    @name = name
    validate_variable :name

    # Legacy formulae can set specs via class ivars
    ensure_specs_set if @stable.nil?

    # If a checksum or version was set in the DSL, but no stable URL
    # was defined, make @stable nil and save callers some trouble
    @stable = nil if @stable and @stable.url.nil?

    # Ensure the bottle URL is set. If it does not have a checksum,
    # then a bottle is not available for the current platform.
    if @bottle and not (@bottle.checksum.nil? or @bottle.checksum.empty?)
      @bottle.url ||= bottle_base_url + bottle_filename(self)
    else
      @bottle = nil
    end

    @active_spec = if @head and ARGV.build_head? then @head # --HEAD
      elsif @devel and ARGV.build_devel? then @devel        # --devel
      elsif @bottle and install_bottle?(self) then @bottle  # bottle available
      elsif @stable.nil? and @head then @head               # head-only
      else @stable                                          # default
      end

    @version = @active_spec.version
    validate_variable :version if @version

    raise "No url provided for formula #{name}" if @active_spec.url.nil?

    # If we got an explicit path, use that, else determine from the name
    @path = path.nil? ? self.class.path(name) : Pathname.new(path)
    @downloader = download_strategy.new(name, @active_spec)
  end

  # Derive specs from class ivars
  def ensure_specs_set
    set_instance_variable :url
    set_instance_variable :version
    set_instance_variable :md5
    set_instance_variable :sha1
    set_instance_variable :sha256

    unless @url.nil?
      @stable = SoftwareSpec.new
      @stable.url(@url)
      @stable.version(@version)
      @stable.md5(@md5)
      @stable.sha1(@sha1)
      @stable.sha256(@sha256)
    end

    if @head.kind_of? String
      url = @head
      @head = HeadSoftwareSpec.new
      @head.url(url, self.class.instance_variable_get("@specs"))
    end
  end

  def url;      @active_spec.url;     end
  def version;  @active_spec.version; end
  def specs;    @active_spec.specs;   end
  def mirrors;  @active_spec.mirrors; end

  # if the dir is there, but it's empty we consider it not installed
  def installed?
    return installed_prefix.children.length > 0
  rescue
    return false
  end

  def explicitly_requested?
    # `ARGV.formulae` will throw an exception if it comes up with an empty list.
    # FIXME: `ARGV.formulae` shouldn't be throwing exceptions, see issue #8823
   return false if ARGV.named.empty?
   ARGV.formulae.include? self
  end

  def linked_keg
    HOMEBREW_REPOSITORY/'Library/LinkedKegs'/@name
  end

  def installed_prefix
    devel_prefix = unless @devel.nil?
      HOMEBREW_CELLAR/@name/@devel.version
    end

    head_prefix = unless @head.nil?
      HOMEBREW_CELLAR/@name/@head.version
    end

    if @active_spec == @head || @head and head_prefix.directory?
      head_prefix
    elsif @active_spec == @devel || @devel and devel_prefix.directory?
      devel_prefix
    else
      prefix
    end
  end

  def prefix
    validate_variable :name
    validate_variable :version
    HOMEBREW_CELLAR+@name+@version
  end
  def rack; prefix.parent end

  def bin;     prefix+'bin'            end
  def doc;     prefix+'share/doc'+name end
  def include; prefix+'include'        end
  def info;    prefix+'share/info'     end
  def lib;     prefix+'lib'            end
  def libexec; prefix+'libexec'        end
  def man;     prefix+'share/man'      end
  def man1;    man+'man1'              end
  def man2;    man+'man2'              end
  def man3;    man+'man3'              end
  def man4;    man+'man4'              end
  def man5;    man+'man5'              end
  def man6;    man+'man6'              end
  def man7;    man+'man7'              end
  def man8;    man+'man8'              end
  def sbin;    prefix+'sbin'           end
  def share;   prefix+'share'          end

  # configuration needs to be preserved past upgrades
  def etc; HOMEBREW_PREFIX+'etc' end
  # generally we don't want var stuff inside the keg
  def var; HOMEBREW_PREFIX+'var' end

  # plist name, i.e. the name of the launchd service
  def plist_name; 'homebrew.mxcl.'+name end
  def plist_path; prefix+(plist_name+'.plist') end

  # Use the @active_spec to detect the download strategy.
  # Can be overriden to force a custom download strategy
  def download_strategy
    @active_spec.download_strategy
  end

  def cached_download
    @downloader.cached_location
  end

  # tell the user about any caveats regarding this package, return a string
  def caveats; nil end

  # any e.g. configure options for this package
  def options; [] end

  # patches are automatically applied after extracting the tarball
  # return an array of strings, or if you need a patch level other than -p1
  # return a Hash eg.
  #   {
  #     :p0 => ['http://foo.com/patch1', 'http://foo.com/patch2'],
  #     :p1 =>  'http://bar.com/patch2',
  #     :p2 => ['http://moo.com/patch5', 'http://moo.com/patch6']
  #   }
  # The final option is to return DATA, then put a diff after __END__. You
  # can still return a Hash with DATA as the value for a patch level key.
  def patches; end

  # rarely, you don't want your library symlinked into the main prefix
  # see gettext.rb for an example
  def keg_only?
    self.class.keg_only_reason || false
  end

  def fails_with? cc
    return false if self.class.cc_failures.nil?
    cc = Compiler.new(cc) unless cc.is_a? Compiler
    return self.class.cc_failures.find do |failure|
      next unless failure.compiler == cc.name
      failure.build.zero? or failure.build >= cc.build
    end
  end

  # sometimes the clean process breaks things
  # skip cleaning paths in a formula with a class method like this:
  #   skip_clean [bin+"foo", lib+"bar"]
  # redefining skip_clean? now deprecated
  def skip_clean? path
    return true if self.class.skip_clean_all?
    to_check = path.relative_path_from(prefix).to_s
    self.class.skip_clean_paths.include? to_check
  end

  # yields self with current working directory set to the uncompressed tarball
  def brew
    validate_variable :name
    validate_variable :version

    stage do
      begin
        patch
        # we allow formulas to do anything they want to the Ruby process
        # so load any deps before this point! And exit asap afterwards
        yield self
      rescue Interrupt, RuntimeError, SystemCallError => e
        puts if Interrupt === e # don't print next to the ^C
        unless ARGV.debug?
          %w(config.log CMakeCache.txt).select{|f| File.exist? f}.each do |f|
            HOMEBREW_LOGS.install f
            puts "#{f} was copied to #{HOMEBREW_LOGS}"
          end
          raise
        end
        onoe e.inspect
        puts e.backtrace

        ohai "Rescuing build..."
        if (e.was_running_configure? rescue false) and File.exist? 'config.log'
          puts "It looks like an autotools configure failed."
          puts "Gist 'config.log' and any error output when reporting an issue."
          puts
        end

        puts "When you exit this shell Homebrew will attempt to finalise the installation."
        puts "If nothing is installed or the shell exits with a non-zero error code,"
        puts "Homebrew will abort. The installation prefix is:"
        puts prefix
        interactive_shell self
      end
    end
  end

  def == b
    name == b.name
  end
  def eql? b
    self == b and self.class.equal? b.class
  end
  def hash
    name.hash
  end
  def <=> b
    name <=> b.name
  end
  def to_s
    name
  end

  # Standard parameters for CMake builds.
  # Using Build Type "None" tells cmake to use our CFLAGS,etc. settings.
  # Setting it to Release would ignore our flags.
  # Setting CMAKE_FIND_FRAMEWORK to "LAST" tells CMake to search for our
  # libraries before trying to utilize Frameworks, many of which will be from
  # 3rd party installs.
  # Note: there isn't a std_autotools variant because autotools is a lot
  # less consistent and the standard parameters are more memorable.
  def std_cmake_args
    %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=None
      -DCMAKE_FIND_FRAMEWORK=LAST
      -Wno-dev
    ]
  end

  def self.class_s name
    #remove invalid characters and then camelcase it
    name.capitalize.gsub(/[-_.\s]([a-zA-Z0-9])/) { $1.upcase } \
                   .gsub('+', 'x')
  end

  # an array of all Formula names
  def self.names
    Dir["#{HOMEBREW_REPOSITORY}/Library/Formula/*.rb"].map{ |f| File.basename f, '.rb' }.sort
  end

  # an array of all Formula, instantiated
  def self.all
    map{ |f| f }
  end
  def self.map
    rv = []
    each{ |f| rv << yield(f) }
    rv
  end
  def self.each
    names.each do |n|
      begin
        yield Formula.factory(n)
      rescue
        # Don't let one broken formula break commands. But do complain.
        onoe "Formula #{n} will not import."
      end
    end
  end

  def inspect
    name
  end

  def self.aliases
    Dir["#{HOMEBREW_REPOSITORY}/Library/Aliases/*"].map{ |f| File.basename f }.sort
  end

  def self.canonical_name name
    name = name.to_s if name.kind_of? Pathname

    formula_with_that_name = HOMEBREW_REPOSITORY+"Library/Formula/#{name}.rb"
    possible_alias = HOMEBREW_REPOSITORY+"Library/Aliases/#{name}"
    possible_cached_formula = HOMEBREW_CACHE_FORMULA+"#{name}.rb"

    if name.include? "/"
      if name =~ %r{(.+)/(.+)/(.+)}
        tapd = HOMEBREW_REPOSITORY/"Library/Taps"/"#$1-#$2".downcase
        tapd.find_formula do |relative_pathname|
          return "#{tapd}/#{relative_pathname}" if relative_pathname.stem.to_s == $3
        end if tapd.directory?
      end
      # Otherwise don't resolve paths or URLs
      name
    elsif formula_with_that_name.file? and formula_with_that_name.readable?
      name
    elsif possible_alias.file?
      possible_alias.realpath.basename('.rb').to_s
    elsif possible_cached_formula.file?
      possible_cached_formula.to_s
    else
      name
    end
  end

  def self.factory name
    # If an instance of Formula is passed, just return it
    return name if name.kind_of? Formula

    # Otherwise, convert to String in case a Pathname comes in
    name = name.to_s

    # If a URL is passed, download to the cache and install
    if name =~ %r[(https?|ftp)://]
      url = name
      name = Pathname.new(name).basename
      target_file = HOMEBREW_CACHE_FORMULA+name
      name = name.basename(".rb").to_s

      HOMEBREW_CACHE_FORMULA.mkpath
      FileUtils.rm target_file, :force => true
      curl url, '-o', target_file

      require target_file
      install_type = :from_url
    else
      name = Formula.canonical_name(name)
      # If name was a path or mapped to a cached formula
      if name.include? "/"
        require name

        # require allows filenames to drop the .rb extension, but everything else
        # in our codebase will require an exact and fullpath.
        name = "#{name}.rb" unless name =~ /\.rb$/

        path = Pathname.new(name)
        name = path.stem
        install_type = :from_path
        target_file = path.to_s
      else
        # For names, map to the path and then require
        require Formula.path(name)
        install_type = :from_name
      end
    end

    begin
      klass_name = self.class_s(name)
      klass = Object.const_get klass_name
    rescue NameError
      # TODO really this text should be encoded into the exception
      # and only shown if the UI deems it correct to show it
      onoe "class \"#{klass_name}\" expected but not found in #{name}.rb"
      puts "Double-check the name of the class in that formula."
      raise LoadError
    end

    return klass.new(name) if install_type == :from_name
    return klass.new(name, target_file)
  rescue LoadError
    raise FormulaUnavailableError.new(name)
  end

  def tap
    if path.realpath.to_s =~ %r{#{HOMEBREW_REPOSITORY}/Library/Taps/(\w+)-(\w+)}
      "#$1/#$2"
    else
      # remotely installed formula are not mxcl/master but this will do for now
      "mxcl/master"
    end
  end

  def self.path name
    HOMEBREW_REPOSITORY+"Library/Formula/#{name.downcase}.rb"
  end

  def deps;          self.class.dependencies.deps;          end
  def external_deps; self.class.dependencies.external_deps; end

  # deps are in an installable order
  # which means if a depends on b then b will be ordered before a in this list
  def recursive_deps
    Formula.expand_deps(self).flatten.uniq
  end

  def self.expand_deps f
    f.deps.map do |dep|
      f_dep = Formula.factory dep.to_s
      expand_deps(f_dep) << f_dep
    end
  end

protected

  # Pretty titles the command and buffers stdout/stderr
  # Throws if there's an error
  def system cmd, *args
    # remove "boring" arguments so that the important ones are more likely to
    # be shown considering that we trim long ohai lines to the terminal width
    pretty_args = args.dup
    pretty_args.delete "--disable-dependency-tracking" if cmd == "./configure" and not ARGV.verbose?
    ohai "#{cmd} #{pretty_args*' '}".strip

    removed_ENV_variables = case if args.empty? then cmd.split(' ').first else cmd end
    when "xcodebuild"
      ENV.remove_cc_etc
    end

    if ARGV.verbose?
      safe_system cmd, *args
    else
      rd, wr = IO.pipe
      pid = fork do
        rd.close
        $stdout.reopen wr
        $stderr.reopen wr
        args.collect!{|arg| arg.to_s}
        exec(cmd, *args) rescue nil
        exit! 1 # never gets here unless exec threw or failed
      end
      wr.close
      out = ''
      out << rd.read until rd.eof?
      Process.wait
      unless $?.success?
        puts out
        raise
      end
    end

    removed_ENV_variables.each do |key, value|
      ENV[key] = value # ENV.kind_of? Hash  # => false
    end if removed_ENV_variables

  rescue
    raise BuildError.new(self, cmd, args, $?)
  end

public

  # For brew-fetch and others.
  def fetch
    # Ensure the cache exists
    HOMEBREW_CACHE.mkpath

    return @downloader.fetch, @downloader
  end

  # For FormulaInstaller.
  def verify_download_integrity fn
    @active_spec.verify_download_integrity(fn)
  end

private

  def stage
    fetched, downloader = fetch
    verify_download_integrity fetched if fetched.kind_of? Pathname
    mktemp do
      downloader.stage
      # Set path after the downloader changes the working folder.
      @buildpath = Pathname.pwd
      yield
      @buildpath = nil
    end
  end

  def patch
    patch_list = Patches.new(patches)
    return if patch_list.empty?

    if patch_list.external_patches?
      ohai "Downloading patches"
      patch_list.download!
    end

    ohai "Patching"
    patch_list.each do |p|
      case p.compression
        when :gzip  then safe_system "/usr/bin/gunzip",  p.compressed_filename
        when :bzip2 then safe_system "/usr/bin/bunzip2", p.compressed_filename
      end
      # -f means don't prompt the user if there are errors; just exit with non-zero status
      safe_system '/usr/bin/patch', '-f', *(p.patch_args)
    end
  end

  def validate_variable name
    v = instance_variable_get("@#{name}")
    raise "Invalid @#{name}" if v.to_s.empty? or v =~ /\s/
  end

  def set_instance_variable(type)
    return if instance_variable_defined? "@#{type}"
    class_value = self.class.send(type)
    instance_variable_set("@#{type}", class_value) if class_value
  end

  def self.method_added method
    raise 'You cannot override Formula.brew' if method == :brew
  end

  class << self
    # The methods below define the formula DSL.

    def self.attr_rw(*attrs)
      attrs.each do |attr|
        class_eval %Q{
          def #{attr}(val=nil)
            val.nil? ? @#{attr} : @#{attr} = val
          end
        }
      end
    end

    attr_rw :homepage, :keg_only_reason, :skip_clean_all, :cc_failures

    Checksum::TYPES.each do |cksum|
      class_eval %Q{
        def #{cksum}(val=nil)
          unless val.nil?
            @stable ||= SoftwareSpec.new
            @stable.#{cksum}(val)
          end
          return @stable ? @stable.#{cksum} : @#{cksum}
        end
      }
    end

    def url val=nil, specs=nil
      if val.nil?
        return @stable.url if @stable
        return @url if @url
      end
      @stable ||= SoftwareSpec.new
      @stable.url(val, specs)
    end

    def stable &block
      return @stable unless block_given?
      instance_eval(&block)
    end

    def bottle url=nil, &block
      return @bottle unless block_given?
      @bottle ||= Bottle.new
      @bottle.instance_eval(&block)
    end

    def devel &block
      return @devel unless block_given?
      @devel ||= SoftwareSpec.new
      @devel.instance_eval(&block)
    end

    def head val=nil, specs=nil
      return @head if val.nil?
      @head ||= HeadSoftwareSpec.new
      @head.url(val, specs)
    end

    def version val=nil
      return @version if val.nil?
      @stable ||= SoftwareSpec.new
      @stable.version(val)
    end

    def mirror val
      @stable ||= SoftwareSpec.new
      @stable.mirror(val)
    end

    def dependencies
      @dependencies ||= DependencyCollector.new
    end

    def depends_on dep
      dependencies.add(dep)
    end

    def conflicts_with formula, opts={}
      message = <<-EOS.undent
      #{formula} cannot be installed alongside #{name.downcase}.
      EOS
      message << "This is because #{opts[:reason]}\n" if opts[:reason]
      if !ARGV.force? then message << <<-EOS.undent
      Please `brew unlink` or `brew uninstall` #{formula} before continuing.
      To install anyway, use:
        brew install --force
        EOS
      end

      dependencies.add ConflictRequirement.new(formula, message)
    end

    def skip_clean paths
      if paths == :all
        @skip_clean_all = true
        return
      end
      @skip_clean_paths ||= []
      [paths].flatten.each do |p|
        @skip_clean_paths << p.to_s unless @skip_clean_paths.include? p.to_s
      end
    end

    def skip_clean_all?
      @skip_clean_all
    end

    def skip_clean_paths
      @skip_clean_paths or []
    end

    def keg_only reason, explanation=nil
      @keg_only_reason = KegOnlyReason.new(reason, explanation.to_s.chomp)
    end

    def fails_with compiler, &block
      @cc_failures ||= CompilerFailures.new
      @cc_failures << if block_given?
        CompilerFailure.new(compiler, &block)
      else
        CompilerFailure.new(compiler)
      end
    end
  end
end

require 'formula_specialties'
