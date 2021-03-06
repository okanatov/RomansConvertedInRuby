require_relative './nextafterdoublei'
require_relative './finish'

module RomanNumbers
  class NextAfterVI
    def go_next(context, number, strio)
      result = 0
      char = strio.getc
      if char == number.one
        result = 1
        context.state = NextAfterDoubleI.new
      else
        strio.ungetc(char)
        context.state = Finish.new
      end
      result
    end
  end
end
