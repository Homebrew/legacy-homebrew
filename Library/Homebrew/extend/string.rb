class String
  def undent
    gsub(/^.{#{slice(/^ +/).length}}/, '')
  end
end
