require 'formula'

module Homebrew extend self
  def fetch
    raise FormulaUnspecifiedError if ARGV.named.empty?

    if ARGV.include? '--deps'
      bucket = []
      ARGV.formulae.each do |f|
        bucket << f
        bucket.concat f.recursive_dependencies.map(&:to_formula)
      end
      bucket.uniq!
    else
      bucket = ARGV.formulae
    end

    puts "Fetching: #{bucket * ', '}" if bucket.size > 1
    bucket.each do |f|
      fetch_formula(f)
      f.resources.each do |r|
        fetch_resource(r)
      end
    end
  end

  def already_fetched? f
    f.cached_download.exist?
  end

  def fetch_resource r
    puts "Resource: #{r.name}"
    fetch_fetchable r
  rescue ChecksumMismatchError => e
    Homebrew.failed = true
    opoo "Resource #{r.name} reports different #{e.hash_type}: #{e.expected}"
  end

  def fetch_formula f
    fetch_fetchable f
  rescue ChecksumMismatchError => e
    Homebrew.failed = true
    opoo "Formula reports different #{e.hash_type}: #{e.expected}"
  end

  private

  def fetch_fetchable f
    f.cached_download.rmtree if already_fetched?(f) && ARGV.force?
    download = f.fetch

    return unless download.file?

    puts "Downloaded to: #{download}" unless already_fetched?(f)
    puts Checksum::TYPES.map { |t| "#{t.to_s.upcase}: #{download.send(t)}" }

    f.verify_download_integrity(download)
  end
end
