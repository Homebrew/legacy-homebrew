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

  def self.copy?(file)
    file = file.downcase
    ext  = File.extname(file)
    file = File.basename(file, ext) if EXTENSIONS.include?(ext)
    BASENAMES.include?(file)
  end
end
