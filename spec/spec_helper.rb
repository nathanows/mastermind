class StringIO
  def noecho
    yield self
  end
end
