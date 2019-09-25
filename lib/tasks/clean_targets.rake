task clean_targets: :environment do
  Target.find_each do |target|
    target.destroy! if (Date.current - target.created_at.to_date) >= 7
  end
end
