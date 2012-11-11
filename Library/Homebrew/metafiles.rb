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

  def include? p
    p = p.to_s # Might be a pathname
    p = p.downcase
    path = Pathname.new(p)
    if @exts.include? path.extname
      p = path.basename(path.extname)
    else
      p = path.basename
    end
    p = p.to_s
    return @metafiles.include? p
  end

end
