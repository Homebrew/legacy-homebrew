class Patches
  # The patches defined in a formula and the DATA from that file
  def initialize patches
    @patches = []
    return if patches.nil?
    n = 0
    normalize_patches(patches).each do |patch_p, urls|
      # Wrap the urls list in an array if it isn't already;
      # DATA.each does each line, which doesn't work so great
      urls = [urls] unless urls.kind_of? Array
      urls.each do |url|
        @patches << Patch.new(patch_p, '%03d-homebrew.diff' % n, url)
        n += 1
      end
    end
  end

  # Collects the urls and output names of all external patches
  def external_curl_args
    @patches.select{|p| p.external?}.collect{|p| p.curl_args}.flatten
  end

  def each(&blk)
    @patches.each(&blk)
  end
  def empty?
    @patches.empty?
  end

private

  def normalize_patches patches
    if patches.kind_of? Hash
      patches
    else
      { :p1 => patches } # We assume -p1
    end
  end

end

class Patch
  attr_reader :compression
  attr_reader :url
  attr_reader :download_filename

  def initialize patch_p, filename, url
    @patch_p = patch_p
    @patch_filename = filename
    @compression = false
    @url = nil

    if url.kind_of? File # true when DATA is passed
      write_data url
    elsif looks_like_url(url)
      @download_filename = @patch_filename
      @url = url # Save URL
      case @url
      when /\.gz$/
        @compression = :gzip
        @download_filename += '.gz'
      when /\.bz2$/
        @compression = :bzip2
        @download_filename += '.bz2'
      end
    else
      # it's a file on the local filesystem
      # use URL as the filename for patch
      @patch_filename = url
    end
  end

  def external?
    !!@url
  end

  def compressed?
    !!@compression
  end

  def patch_args
    ["-#{@patch_p}", '-i', @patch_filename]
  end

  def curl_args
    [@url, '-o', @download_filename]
  end

private

  # Write the given file object (DATA) out to a local file for patch
  def write_data f
    pn = Pathname.new @patch_filename
    pn.write(brew_var_substitution(f.read.to_s))
  end

  # Do any supported substitutions of HOMEBREW vars in a DATA patch
  def brew_var_substitution s
    s.gsub("HOMEBREW_PREFIX", HOMEBREW_PREFIX)
  end

  def looks_like_url str
    str =~ %r[^\w+\://]
  end
end
