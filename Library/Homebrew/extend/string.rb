class String
  def undent
    gsub /^.{#{slice(/^ +/).length}}/, ''
  end
end

if __FILE__ == $0
  undented = <<-EOS.undent
    hi
....my friend over
    there
  EOS
  
  assert undented == "hi\nmy friend over\nthere\n"
end
