
require 'spec_helper'


module Mytodo
  describe Edit do
    describe "#open" do
      it "open file my_todo.yml" do
#        if command == "my_todo --edit"
          system("emacs ~/.my_help/my_todo.yml")
#        end
      end
    end
  end
end
