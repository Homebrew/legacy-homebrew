require 'stringio'
require 'checksum'

module Patches
  # This mixin contains all the patch-related code.

  # There is a new DSL for specifying patches:
  #   patch :p0, 'http://example.com/patch.diff', <sha256>
  #   patch :p1, DATA
  # DATA is for patches built into the formula: put __END__ at the end
  # of the formula script and append the diff.

  # The old "def patches" method is still supported:
  # return an array of strings, or if you need a patch level other than -p1
  # return a Hash eg.
  #   {
  #     :p0 => ['http://foo.com/patch1', 'http://foo.com/patch2', DATA],
  #     :p1 =>  'http://bar.com/patch2'
  #   }
  def patches; end

  # We want to be able to have "patch :p1, DATA" in our formula; however,
  # when the formulary loads the formula using require, DATA is not defined
  # (since the formula is not the main script), so we define it here to avoid
  # a load error.
  DATA = nil unless defined?(DATA)

  def self.included(base)
    base.class_eval do
      def self.patchlist
        @patchlist ||= []
      end

      # This is the new, preferred DSL that allows a checksum to be specified.
      def self.patch patch_p, url_or_io, sha256=nil
        patchlist << Patch.new(patch_p, '%03d-homebrew.diff' % patchlist.length, url_or_io, sha256)
      end
    end
  end

  def patchlist
    unless @patchlist
      @patchlist = self.class.patchlist
      process_legacy_patches
    end
    @patchlist
  end

  def process_legacy_patches
    # Handle legacy "patches" method
    legacy_p = patches
    return if legacy_p.nil? or legacy_p.empty?
    # This can be an array of patches, or a hash with patch_p as keys
    legacy_p = { :p1 => legacy_p } unless legacy_p.kind_of? Hash
    legacy_p.each do |patch_p, urls|
      # This can be an array of urls, but also an individual url, or DATA
      urls = [urls] unless urls.kind_of? Array
      urls.each {|url| self.class.patch patch_p, url, ""}
    end
  end

  def apply_patches
    return if patchlist.empty?

    external_patches = patchlist.select{|p| p.external?}
    unless external_patches.empty?
      ohai "Downloading patches"
      # downloading all at once is much more efficient, especially for FTP
      curl *(external_patches.collect{|p| p.curl_args}.flatten)
      external_patches.each do |p|
        p.stage!
        begin
          Pathname.new(p.compressed_filename).verify_checksum p.checksum
        rescue ChecksumMissingError
          # accept this silently for now
        rescue ChecksumMismatchError => e
          e.advice = "Bad patch: " + p.url
          raise e
        end
      end
    end
    patchlist.each{|p| p.write_data! if p.data?}

    ohai "Patching"
    patchlist.each do |p|
      case p.compression
        when :gzip  then safe_system "/usr/bin/gunzip",  p.compressed_filename
        when :bzip2 then safe_system "/usr/bin/bunzip2", p.compressed_filename
      end
      # -f means don't prompt the user if there are errors; just exit with non-zero status
      safe_system '/usr/bin/patch', '-f', *(p.patch_args)
    end
  end
end

class Patch
  # Used by formula to unpack after downloading
  attr_reader :compression, :compressed_filename, :checksum
  # Used by audit
  attr_reader :url

  def initialize patch_p, filename, url, sha256
    @patch_p = patch_p
    @patch_filename = filename
    @compressed_filename = @patch_filename
    @compression = nil
    @url = nil
    @data = nil
    @checksum = Checksum.new(:sha256, sha256)

    if url.kind_of? IO or url.kind_of? StringIO
      @data = url.read.to_s
      # File-like objects. Most common when DATA is passed.
      # We can't write this during initialization because we're still in the formula
      # loading phase.
    elsif looks_like_url(url)
      @url = url # Save URL to mark this as an external patch
    else
      # it's a file on the local filesystem
      # use URL as the filename for patch
      @patch_filename = url
    end
  end

  # rename the downloaded file to take compression into account
  def stage!
    write_data unless @data.nil?
    return unless external?
    detect_compression!
    case @compression
    when :gzip
      @compressed_filename = @patch_filename + '.gz'
      FileUtils.mv @patch_filename, @compressed_filename
    when :bzip2
      @compressed_filename = @patch_filename + '.bz2'
      FileUtils.mv @patch_filename, @compressed_filename
    end
  end

  # Write the given file object (DATA) out to a local file for patch
  def write_data!
    pn = Pathname.new @patch_filename
    pn.write(brew_var_substitution(@data))
  end

  def data?
    not @data.nil?
  end

  def external?
    not @url.nil?
  end

  def patch_args
    ["-#{@patch_p}", '-i', @patch_filename]
  end

  def curl_args
    [@url, '-o', @patch_filename]
  end

  private

  # Detect compression type from the downloaded patch.
  def detect_compression!
    # If nil we have not tried to detect yet
    if @compression.nil?
      path = Pathname.new(@patch_filename)
      if path.exist?
        @compression = path.compression_type
        @compression ||= :none # If nil, convert to :none
      end
    end
  end

  # Do any supported substitutions of HOMEBREW vars in a DATA patch
  def brew_var_substitution s
    s.gsub("HOMEBREW_PREFIX", HOMEBREW_PREFIX)
  end

  def looks_like_url str
    str =~ %r[^\w+\://]
  end
end
