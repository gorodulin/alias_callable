# frozen_string_literal: true

RSpec.shared_examples "has instance methods" do |method_names|
  method_names.each do |method_name|
    it "responds to :#{method_name} instance method" do
      expect(
        subject.instance_methods(true).concat(subject.private_instance_methods(true))
      ).to include(method_name)
    end
  end
end
