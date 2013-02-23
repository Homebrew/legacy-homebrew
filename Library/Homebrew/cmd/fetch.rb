require 'formula'

# Downloads the tarballs for the given formulae to the Cache

module Homebrew extend self
  def fetch
    raise FormulaUnspecifiedError if ARGV.named.empty?

    if ARGV.include? '--deps'
      bucket = []
      ARGV.formulae.each do |f|
        bucket << f
        bucket << f.recursive_dependencies.map(&:to_formula)
      end

      bucket = bucket.flatten.uniq
    else
      bucket = ARGV.formulae
    end

    puts "Fetching: #{bucket * ', '}" if bucket.size > 1
    bucket.each { |f| fetch_formula(f) }
  end

  def already_fetched? f
    f.cached_download.exist?
  end

  def fetch_formula f
    f.cached_download.rmtree if already_fetched?(f) && ARGV.force?
    tarball, _ = f.fetch

    # FIXME why are strategies returning different types?
    return unless tarball.is_a? Pathname

    puts "Downloaded to: #{tarball}" unless already_fetched?(f)
    puts Checksum::TYPES.map { |t| "#{t.to_s.upcase}: #{tarball.send(t)}" }

    f.verify_download_integrity(tarball)
  rescue ChecksumMismatchError => e
    Homebrew.failed = true
    opoo "Formula reports different #{e.hash_type}: #{e.expected}"
  end
end
