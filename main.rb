require "net/http"
require "thread"

class RandomNumber
  URL = "http://www.random.com/integers"
   def initalize(min = 0, max = 1, buffsize = 1000, slack=300)
     @buffer = SizedQueue.new(buffsize)
     @min, @max, @slack = min, max, slack
   end
  
  def fillbuffer
    count = @buffer.max - @buffer.size
    
    url = URI.parse(URL)
    url.query = URI.encode_www_form(
      col: 1, base: 10, format: "plain", rnd: "new",
      num: count, min: @min, max: @max
    )
    Net::HTTP.get(url).lines.each do |line|
      @buffer.push line.to_i
    end
  end
  def rand
    if @buffer.size < @slack && !@thread.alive?
      @thread = Thread.new {fillbiffer}
    end
    @buffer.pop
  end
end
t = RandomNumber.new(1,6,1000,300)
10000.times do |n|
  count[t.rand] += 1
end

p count
