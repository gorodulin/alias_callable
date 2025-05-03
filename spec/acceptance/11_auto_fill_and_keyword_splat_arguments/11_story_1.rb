# frozen_string_literal: true

# THIS IS A STORY CODE SNIPPET

module Story11

  class CreateRecord
    def self.call(logger: nil, **attributes)
      attributes.merge(logger: logger)
    end
  end

  class DummyKlass
    alias_callable :create_record, CreateRecord, auto_fill: [:logger]

    def initialize
      @logger = "LOGGER"
    end
  end

end
