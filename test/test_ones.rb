require 'simplecov'
if ENV['COVERAGE']
  SimpleCov.start do
    add_filter 'test/'
  end
end

require 'minitest/autorun'
require_relative '../lib/parser/ones'

# Verifies Romans one numbers
class OnesTest < MiniTest::Test

  include RomanNumbers

  def setup
    @ones = Ones.new
  end

  def test_ones
    assert_equal('I', @ones.one)
  end

  def test_fives
    assert_equal('V', @ones.five)
  end

  def test_tens
    assert_equal('X', @ones.ten)
  end

  def test_not_end
    assert(false == @ones.end?('a'))
  end

  def test_end
    assert(true == @ones.end?(nil))
  end
end
