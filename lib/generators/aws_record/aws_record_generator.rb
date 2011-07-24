  class AwsRecordGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)
  
    def create_model_file
          create_file "app/models/#{file_name}.rb", <<-FILE
class #{class_name} < AWS::Record::Base
end
          FILE
    end
  end
