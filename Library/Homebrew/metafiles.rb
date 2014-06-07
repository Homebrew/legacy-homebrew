class Metafiles

  def initialize
    @exts = %w[.md .html .rtf .txt]
    @metafiles = %w[
      about authors changelog changes copying copyright history license
      licence news notes notice readme todo]
  end

  def + other
    @metafiles + other
  end

  def should_copy? file
    include? file
  end

  def should_list? file
    return false if %w[.DS_Store INSTALL_RECEIPT.json].include? file
    not include? file
  end

  private

  def include?(path)
    path = path.to_s.downcase
    ext  = File.extname(path)

    if EXTENSIONS.include?(ext)
      file = File.basename(path, ext)
    else
      file = File.basename(path)
    end

    return @metafiles.include?(file)
  end
end
