# frozen_string_literal: true

RSpec.shared_examples "has class methods" do |method_names|
  method_names.each do |method_name|
    it "responds to :#{method_name} class method" do
      expect(
        subject.singleton_class.instance_methods(true) +
        subject.singleton_class.private_instance_methods(true)
      ).to include(method_name)
    end
  end
end
