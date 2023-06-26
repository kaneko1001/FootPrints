# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "------------admin create----------------"
Admin.destroy_all
Admin.create!(
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
)

puts "------------customer create----------------"
Customer.destroy_all
customers = Customer.create!(
  [
    { email: 'olivia@example.com', name: 'Olivia', password: 'password', profile_image: ActiveStorage::Blob.create_after_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename: "sample-user1.jpg") },
    { email: 'james@example.com', name: 'James', password: 'password', profile_image: ActiveStorage::Blob.create_after_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename: "sample-user2.jpg") },
    { email: 'lucas@example.com', name: 'Lucas', password: 'password', profile_image: ActiveStorage::Blob.create_after_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename: "sample-user3.jpg") }
  ]
)

puts "------------Post create----------------"
Post.destroy_all
Post.create!(
  [
    {
      title: '岩手県に旅行に行きました。',
      images: [
        ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename: "sample-post1.jpg"),
        ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename: "sample-post2.jpg")
      ],
      location: [
        { name: '盛岡八幡宮' },
        { name: '初駒わんこそば本店' }
      ],
      departure_date: Date.new(2023, 6, 25),
      return_date: Date.new(2023, 6, 30),
      content: 'わんこそばを食べました',
      customer_id: customers[0].id
    },

    {
      title: '北海道',
      images: [
        ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename: "sample-post3.jpg"),
        ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post7.jpg"), filename: "sample-post7.jpg"),
        ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post8.jpg"), filename: "sample-post8.jpg")
      ],
      location: [
        { name: '北海道青い池' },
        { name: 'クラーク博士像' },
        { name: '札幌市時計台' }
      ],
      departure_date: Date.new(2023, 5, 25),
      return_date: Date.new(2023, 6, 10),
      content: '北海道に行ってきました！とてもきれいでした。',
      customer_id: customers[1].id
    },

    {
      title: '横浜赤レンガ倉庫に行ってきました。',
      images: [
        ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post6.jpg"), filename: "sample-post6.jpg")
      ],
      location: [
        { name: '横浜赤レンガ倉庫' }
      ],
      departure_date: Date.new(2023, 6, 10),
      return_date: Date.new(2023, 6, 10),
      content: '日帰りで、横浜赤レンガ倉庫に行ってきました。ライトアップされていてとてもきれいでした',
      customer_id: customers[2].id
    }
  ]
)

puts "------------Comment create----------------"
Comment.create!(
  [
    { customer_id: customers[0].id, post_id: Post.second.id, comment: 'とても綺麗ですね！' },
    { customer_id: customers[1].id, post_id: Post.first.id, comment: '何杯食べれたのですか？' }
  ]
)