
namespace :aws do
  desc "Creates all required SimpleDB domains"
  task :create_domains => :environment do
    puts "Creating Amazon SimpleDB domains:"
    Dir['app/models/*.rb'].map {|f| File.basename(f, '.*').camelize.constantize }.each do |model|
      if model.superclass == AWS::Record::Base
        puts " -> #{model.to_s}"
        model.create_domain        
      end
    end
    
  end
end

