require 'irb'
require 'rubypython'

# Load IRB with current binding
# http://jameskilton.com/2009/04/02/embedding-irb-into-your-ruby-application 
module IRB # :nodoc:
  def self.start_session(binding)
    unless @__initialized
      args = ARGV
      ARGV.replace(ARGV.dup)
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end

    workspace = WorkSpace.new(binding)

    irb = Irb.new(workspace)

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    catch(:IRB_EXIT) do
      irb.eval_input
    end
  end
end

# Start python and load fontforge with font
RubyPython.start
fontforge = RubyPython.import('fontforge')
font = fontforge.open('test/font/font.otf')

# Start session
IRB.start_session(binding)

# Close Python
RubyPython.stop
