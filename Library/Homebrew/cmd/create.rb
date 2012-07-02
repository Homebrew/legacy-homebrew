require 'formula'
require 'blacklist'

module Homebrew extend self
  def create
    if ARGV.include? '--macports'
      exec "open", "http://www.macports.org/ports.php?by=name&substr=#{ARGV.next}"
    elsif ARGV.include? '--fink'
      exec "open", "http://pdb.finkproject.org/pdb/browse.php?summary=#{ARGV.next}"
    elsif ARGV.named.empty?
      raise UsageError
    else
      HOMEBREW_CACHE.mkpath
      paths = ARGV.named.map do |url|
        fc = FormulaCreator.new
        fc.url = url
        fc.mode = if ARGV.include? '--cmake'
          :cmake
        elsif ARGV.include? '--autotools'
          :autotools
        end

        if fc.name.nil? or fc.name.to_s.strip.empty?
          path = Pathname.new url
          print "Formula name [#{path.stem}]: "
          fc.name = __gets || path.stem
          fc.path = Formula.path fc.name
        end

        unless ARGV.force?
          if msg = blacklisted?(fc.name)
            raise "#{fc.name} is blacklisted for creation.\n#{msg}\nIf you really want to create this formula use --force."
          end

          if Formula.aliases.include? fc.name
            realname = Formula.canonical_name fc.name
            raise <<-EOS.undent
              The formula #{realname} is already aliased to #{fc.name}
              Please check that you are not creating a duplicate.
              To force creation use --force.
              EOS
          end
        end
        fc.generate
        fc.path
      end
      puts "Please `brew audit "+paths.collect{|p|p.basename(".rb")}*" "+"` before submitting, thanks."
      exec_editor *paths
    end
  end

  def __gets
    gots = $stdin.gets.chomp
    if gots.empty? then nil else gots end
  end
end

class FormulaCreator
  attr :url
  attr :sha1
  attr :name, true
  attr :path, true
  attr :mode, true

  def url= url
    @url = url
    path = Pathname.new url
    /(.*?)[-_.]?#{path.version}/.match path.basename
    @name = $1
    @path = Formula.path $1 unless $1.nil?
  end

  def version
    Pathname.new(url).version
  end

  def generate
    raise "#{path} already exists" if path.exist?

    require 'digest'
    require 'erb'

    if version.nil?
      opoo "Version cannot be determined from URL."
      puts "You'll need to add an explicit 'version' to the formula."
    else
      puts "Version detected as #{version}."
    end

    unless ARGV.include? "--no-fetch" and version
      strategy = detect_download_strategy url
      @sha1 = strategy.new(url, name, version, nil).fetch.sha1 if strategy == CurlDownloadStrategy
    end

    path.write ERB.new(template, nil, '>').result(binding)
  end

  def template; <<-EOS.undent
    require 'formula'

    # Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
    # PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

    class #{Formula.class_s name} < Formula
      homepage ''
      url '#{url}'
      sha1 '#{sha1}'

    <% if mode == :cmake %>
      depends_on 'cmake' => :build
    <% elsif mode == nil %>
      # depends_on 'cmake' => :build
    <% end %>
    depends_on :x11 # if your formula requires any X11/XQuartz components

      def install
        # ENV.j1  # if your formula's build system can't parallelize

    <% if mode == :cmake %>
        system "cmake", ".", *std_cmake_args
    <% elsif mode == :autotools %>
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
                              "--prefix=\#{prefix}"
    <% else %>
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
                              "--prefix=\#{prefix}"
        # system "cmake", ".", *std_cmake_args
    <% end %>
        system "make install" # if this fails, try separate make/make install steps
      end

      def test
        # This test will fail and we won't accept that! It's enough to just replace
        # "false" with the main program this formula installs, but it'd be nice if you
        # were more thorough. Run the test with `brew test #{name}`.
        system "false"
      end
    end
    EOS
  end
end
