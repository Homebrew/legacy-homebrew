class Metafiles
  EXTENSIONS = %w[.md .html .rtf .txt]
  BASENAMES = %w[
    about authors changelog changes copying copyright history license licence
    news notes notice readme todo
  ]

  def self.list?(file)
    return false if %w[.DS_Store INSTALL_RECEIPT.json].include?(file)
    !copy?(file)
  end

  def self.copy?(path)
    path = path.to_s.downcase
    ext  = File.extname(path)

    if EXTENSIONS.include?(ext)
      basename = File.basename(path, ext)
    else
      basename = File.basename(path)
    end

    return BASENAMES.include?(basename)
  end
end
