class Version
  def slice(*args)
    opoo "Calling slice on versions is deprecated, use: to_s.slice"
    to_s.slice(*args)
  end
end
