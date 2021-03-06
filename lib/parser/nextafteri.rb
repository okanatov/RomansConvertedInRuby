require_relative './nextafterdoublei'
require_relative './finish'

module RomanNumbers
  class NextAfterI
    def go_next(context, number, strio)
      result = 0
      char = strio.getc
      if char == number.one
        result = 1
        context.state = NextAfterDoubleI.new
      elsif char == number.five
        result = 3
        context.state = Finish.new
      elsif char == number.ten
        result = 8
        context.state = Finish.new
      else
        strio.ungetc(char)
        context.state = Finish.new
      end
      result
    end
  end
end
