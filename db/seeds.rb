User.first(2).each do |u|
  2.times do |i|
    s = u.stickers.create!(
      title: "Sample #{i+1}",
      caption: "by #{u.name}",
      public: true
    )
    s.image.attach(io: File.open(Rails.root.join("tmp/storage/image/cat.jpg")), filename: "cat.jpg")
  end
end
