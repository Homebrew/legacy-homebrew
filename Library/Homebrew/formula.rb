require 'download_strategy'
require 'fileutils'

# Defines a URL and download method for a stable or HEAD build
class SoftwareSpecification
  attr_reader :url, :specs, :using

  VCS_SYMBOLS = {
    :bzr     => BazaarDownloadStrategy,
    :curl    => CurlDownloadStrategy,
    :cvs     => CVSDownloadStrategy,
    :git     => GitDownloadStrategy,
    :hg      => MercurialDownloadStrategy,
    :nounzip => NoUnzipCurlDownloadStrategy,
    :post    => CurlPostDownloadStrategy,
    :svn     => SubversionDownloadStrategy,
  }

  def initialize url, specs=nil
    raise "No url provided" if url.nil?
    @url = url
    unless specs.nil?
      # Get download strategy hint, if any
      @using = specs.delete :using
      # The rest of the specs are for source control
      @specs = specs
    end
  end

  # Returns a suitable DownloadStrategy class that can be
  # used to retreive this software package.
  def download_strategy
    return detect_download_strategy(@url) if @using.nil?

    # If a class is passed, assume it is a download strategy
    return @using if @using.kind_of? Class

    detected = VCS_SYMBOLS[@using]
    raise "Unknown strategy #{@using} was requested." unless detected
    return detected
  end

  def detect_version
    Pathname.new(@url).version
  end
end

class BottleSoftwareSpecification < SoftwareSpecification
  def download_strategy
    return CurlBottleDownloadStrategy if @using.nil?
    raise "Strategies cannot be used with bottles."
  end
end


# Used to annotate formulae that duplicate OS X provided software
# or cause conflicts when linked in.
class KegOnlyReason
  attr_reader :reason, :explanation

  def initialize reason, explanation=nil
    @reason = reason
    @explanation = explanation
  end

  def to_s
    if @reason == :provided_by_osx
      <<-EOS.chomp
Mac OS X already provides this program and installing another version in
parallel can cause all kinds of trouble.

#{@explanation}
EOS
    else
      @reason
    end
  end
end


# Used to annotate formulae that won't build correctly with LLVM.
class FailsWithLLVM
  attr_reader :msg, :data, :build

  def initialize msg=nil, data=nil
    @msg = msg || "(No specific reason was given)"
    @data = data
    @build = data.delete :build rescue nil
  end

  def reason
    s = @msg
    s += "Tested with LLVM build #{@build}" unless @build == nil
    s += "\n"
    return s
  end
end


# Derive and define at least @url, see Library/Formula for examples
class Formula
  include FileUtils

  attr_reader :name, :path, :url, :version, :homepage, :specs, :downloader
  attr_reader :bottle, :bottle_sha1

  # Homebrew determines the name
  def initialize name='__UNKNOWN__', path=nil
    set_instance_variable 'homepage'
    set_instance_variable 'url'
    set_instance_variable 'bottle'
    set_instance_variable 'bottle_sha1'
    set_instance_variable 'head'
    set_instance_variable 'specs'

    set_instance_variable 'stable'
    set_instance_variable 'unstable'

    if @head and (not @url or ARGV.build_head?)
      @url = @head
      @version = 'HEAD'
      @spec_to_use = @unstable
    elsif pourable?
      @spec_to_use = BottleSoftwareSpecification.new(@bottle, @specs)
    else
      if @stable.nil?
        @spec_to_use = SoftwareSpecification.new(@url, @specs)
      else
        @spec_to_use = @stable
      end
    end

    raise "No url provided for formula #{name}" if @url.nil?
    @name=name
    validate_variable :name

    @path=path

    set_instance_variable 'version'
    @version ||= @spec_to_use.detect_version
    validate_variable :version if @version

    CHECKSUM_TYPES.each { |type| set_instance_variable type }

    @downloader=download_strategy.new @spec_to_use.url, name, version, @spec_to_use.specs
  end

  # if the dir is there, but it's empty we consider it not installed
  def installed?
    return installed_prefix.children.length > 0
  rescue
    return false
  end

  def installed_prefix
    head_prefix = HOMEBREW_CELLAR+@name+'HEAD'
    if @version == 'HEAD' || head_prefix.directory?
      head_prefix
    else
      prefix
    end
  end

  def path
    if @path.nil?
      return self.class.path(name)
    else
      return @path
    end
  end

  def prefix
    validate_variable :name
    validate_variable :version
    HOMEBREW_CELLAR+@name+@version
  end

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

  # Use the @spec_to_use to detect the download strategy.
  # Can be overriden to force a custom download strategy
  def download_strategy
    @spec_to_use.download_strategy
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

  def fails_with_llvm?
    self.class.fails_with_llvm_reason || false
  end

  # sometimes the clean process breaks things
  # skip cleaning paths in a formula with a class method like this:
  #   skip_clean [bin+"foo", lib+"bar"]
  # redefining skip_clean? in formulas is now deprecated
  def skip_clean? path
    return true if self.class.skip_clean_all?
    to_check = path.relative_path_from(prefix).to_s
    self.class.skip_clean_paths.include? to_check
  end

  # yields self with current working directory set to the uncompressed tarball
  def brew
    validate_variable :name
    validate_variable :version

    handle_llvm_failure(fails_with_llvm?) if fails_with_llvm?

    stage do
      begin
        patch
        # we allow formulas to do anything they want to the Ruby process
        # so load any deps before this point! And exit asap afterwards
        yield self
      rescue Interrupt, RuntimeError, SystemCallError => e
        raise unless ARGV.debug?
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
  # Note: there isn't a std_autotools variant because autotools is a lot
  # less consistent and the standard parameters are more memorable.
  def std_cmake_parameters
    "-DCMAKE_INSTALL_PREFIX='#{prefix}' -DCMAKE_BUILD_TYPE=None -Wno-dev"
  end

  def handle_llvm_failure llvm
    unless (ENV['HOMEBREW_USE_LLVM'] or ARGV.include? '--use-llvm' or ARGV.include? '--use-clang')
      ENV.gcc_4_2 if default_cc =~ /llvm/
      return
    end

    opoo "LLVM was requested, but this formula is reported as not working with LLVM:"
    puts llvm.reason

    if ARGV.force?
      puts "Continuing anyway.\n" +
           "If this works, let us know so we can update the formula to remove the warning."
    else
      puts "Continuing with GCC 4.2 instead.\n"+
           "(Use `brew install --force #{name}` to force use of LLVM.)"
      ENV.gcc_4_2
    end
    puts
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
    formula_with_that_name = HOMEBREW_REPOSITORY+"Library/Formula/#{name}.rb"
    possible_alias = HOMEBREW_REPOSITORY+"Library/Aliases/#{name}"
    possible_cached_formula = HOMEBREW_CACHE_FORMULA+"#{name}.rb"

    if name.include? "/"
      # Don't resolve paths or URLs
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

  def self.path name
    HOMEBREW_REPOSITORY+"Library/Formula/#{name.downcase}.rb"
  end

  def deps
    self.class.deps or []
  end

  def external_deps
    self.class.external_deps or {}
  end

  # deps are in an installable order
  # which means if a depends on b then b will be ordered before a in this list
  def recursive_deps
    Formula.expand_deps(self).flatten.uniq
  end

  def self.expand_deps f
    f.deps.map do |dep|
      dep = Formula.factory dep
      expand_deps(dep) << dep
    end
  end

  def pourable?
    @bottle and not ARGV.build_from_source?
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

    if ARGV.verbose?
      safe_system cmd, *args
    else
      rd, wr = IO.pipe
      pid = fork do
        rd.close
        $stdout.reopen wr
        $stderr.reopen wr
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
  rescue
    raise BuildError.new(self, cmd, args, $?)
  end

private
  # Create a temporary directory then yield. When the block returns,
  # recursively delete the temporary directory.
  def mktemp
    # I used /tmp rather than `mktemp -td` because that generates a directory
    # name with exotic characters like + in it, and these break badly written
    # scripts that don't escape strings before trying to regexp them :(

    # If the user has FileVault enabled, then we can't mv symlinks from the
    # /tmp volume to the other volume. So we let the user override the tmp
    # prefix if they need to.
    tmp_prefix = ENV['HOMEBREW_TEMP'] || '/tmp'
    tmp=Pathname.new `/usr/bin/mktemp -d #{tmp_prefix}/homebrew-#{name}-#{version}-XXXX`.strip
    raise "Couldn't create build sandbox" if not tmp.directory? or $? != 0
    begin
      wd=Dir.pwd
      Dir.chdir tmp
      yield
    ensure
      Dir.chdir wd
      tmp.rmtree
    end
  end

  CHECKSUM_TYPES=[:md5, :sha1, :sha256].freeze

  def verify_download_integrity fn
    require 'digest'
    if not pourable?
      type=CHECKSUM_TYPES.detect { |type| instance_variable_defined?("@#{type}") }
      type ||= :md5
      supplied=instance_variable_get("@#{type}")
      type=type.to_s.upcase
    else
      supplied=instance_variable_get("@bottle_sha1")
      type="SHA1"
    end

    hasher = Digest.const_get(type)
    hash = fn.incremental_hash(hasher)

    if supplied and not supplied.empty?
      message = <<-EOF
#{type} mismatch
Expected: #{supplied}
Got: #{hash}
Archive: #{fn}
(To retry an incomplete download, remove the file above.)
EOF
      raise message unless supplied.upcase == hash.upcase
    else
      opoo "Cannot verify package integrity"
      puts "The formula did not provide a download checksum"
      puts "For your reference the #{type} is: #{hash}"
    end
  end

  def stage
    HOMEBREW_CACHE.mkpath
    fetched = @downloader.fetch
    verify_download_integrity fetched if fetched.kind_of? Pathname

    if not pourable?
      mktemp do
        @downloader.stage
        yield
      end
    else
      HOMEBREW_CELLAR.cd do
        @downloader.stage
        yield
      end
    end
  end

  def patch
    return if patches.nil? or pourable?

    if not patches.kind_of? Hash
      # We assume -p1
      patch_defns = { :p1 => patches }
    else
      patch_defns = patches
    end

    patch_list=[]
    n=0
    patch_defns.each do |arg, urls|
      # DATA.each does each line, which doesn't work so great
      urls = [urls] unless urls.kind_of? Array

      urls.each do |url|
        p = {:filename => '%03d-homebrew.diff' % n+=1, :compression => false}

        if defined? DATA and url == DATA
          pn=Pathname.new p[:filename]
          pn.write DATA.read
        elsif url =~ %r[^\w+\://]
          out_fn = p[:filename]
          case url
          when /\.gz$/
            p[:compression] = :gzip
            out_fn += '.gz'
          when /\.bz2$/
            p[:compression] = :bzip2
            out_fn += '.bz2'
          end
          p[:curl_args] = [url, '-o', out_fn]
        else
          # it's a file on the local filesystem
          p[:filename] = url
        end

        p[:args] = ["-#{arg}", '-i', p[:filename]]

        patch_list << p
      end
    end

    return if patch_list.empty?

    ohai "Downloading patches"
    # downloading all at once is much more efficient, especially for FTP
    patches = patch_list.collect{|p| p[:curl_args]}.select{|p| p}.flatten
    curl(*patches)

    ohai "Patching"
    patch_list.each do |p|
      case p[:compression]
        when :gzip  then safe_system "/usr/bin/gunzip",  p[:filename]+'.gz'
        when :bzip2 then safe_system "/usr/bin/bunzip2", p[:filename]+'.bz2'
      end
      # -f means it doesn't prompt the user if there are errors, if just
      # exits with non-zero status
      safe_system '/usr/bin/patch', '-f', *(p[:args])
    end
  end

  def validate_variable name
    v = instance_variable_get("@#{name}")
    raise "Invalid @#{name}" if v.to_s.empty? or v =~ /\s/
  end

  def set_instance_variable(type)
    unless instance_variable_defined? "@#{type}"
      class_value = self.class.send(type)
      instance_variable_set("@#{type}", class_value) if class_value
    end
  end

  def method_added method
    raise 'You cannot override Formula.brew' if method == 'brew'
  end

  class << self
    # The methods below define the formula DSL.
    attr_reader :stable, :unstable

    def self.attr_rw(*attrs)
      attrs.each do |attr|
        class_eval %Q{
          def #{attr}(val=nil)
            val.nil? ? @#{attr} : @#{attr} = val
          end
        }
      end
    end

    attr_rw :version, :homepage, :specs, :deps, :external_deps
    attr_rw :keg_only_reason, :fails_with_llvm_reason, :skip_clean_all
    attr_rw :bottle, :bottle_sha1
    attr_rw(*CHECKSUM_TYPES)

    def head val=nil, specs=nil
      return @head if val.nil?
      @unstable = SoftwareSpecification.new(val, specs)
      @head = val
      @specs = specs
    end

    def url val=nil, specs=nil
      return @url if val.nil?
      @stable = SoftwareSpecification.new(val, specs)
      @url = val
      @specs = specs
    end

    def depends_on name
      @deps ||= []
      @external_deps ||= {:python => [], :perl => [], :ruby => [], :jruby => []}

      case name
      when String, Formula
        @deps << name
      when Hash
        key, value = name.shift
        case value
        when :python, :perl, :ruby, :jruby
          @external_deps[value] << key
        when :optional, :recommended, :build
          @deps << key
        else
          raise "Unsupported dependency type #{value}"
        end
      when Symbol
        opoo "#{self.name} -- #{name}: Using symbols for deps is deprecated; use a string instead"
        @deps << name.to_s
      else
        raise "Unsupported type #{name.class}"
      end
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

    # 'aka' is no longer used to define aliases, so have it print out
    # a notice about the change. This will alert people with private
    # formulae that they need to update.
    # This notice will be removed in version 0.9
    def aka args
      onoe "#{name}: 'aka' is no longer used to define aliases"
      puts "To define an alias, create a relative symlink from"
      puts "Aliases to Formula. The name of the symlink will be"
      puts "detected as an alias for the target formula."
    end

    def keg_only reason, explanation=nil
      @keg_only_reason = KegOnlyReason.new(reason, explanation.to_s.chomp)
    end

    def fails_with_llvm msg=nil, data=nil
      @fails_with_llvm_reason = FailsWithLLVM.new(msg, data)
    end
  end
end

# see ack.rb for an example usage
class ScriptFileFormula < Formula
  def install
    bin.install Dir['*']
  end
end

# see flac.rb for example usage
class GithubGistFormula < ScriptFileFormula
  def initialize name='__UNKNOWN__', path=nil
    super name, path
    @version=File.basename(File.dirname(url))[0,6]
  end
end
