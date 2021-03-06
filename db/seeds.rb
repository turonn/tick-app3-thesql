schools = School.create([
                          {
                            name: 'Paint Valley',
                            mascot: 'Bearcats',
                            address1: '7454 US Rt 50',
                            city: 'Bainbridge',
                            state: 'OH',
                            zip: '45612',
                            logo_location: 'logos/PaintValley.png'
                          },
                          {
                            name: 'Adena',
                            mascot: 'Warriors',
                            address1: '3367 Co Rd 550',
                            city: 'Frankfort',
                            state: 'OH',
                            zip: '45628',
                            logo_location: 'logos/Adena.png'
                          },
                          {
                            name: 'Piketon',
                            mascot: 'Redstreaks',
                            address1: '1414 Piketon Rd',
                            city: 'Piketon',
                            state: 'OH',
                            zip: '45661',
                            logo_location: 'logos/Piketon.png'
                          },
                          {
                            name: 'Unioto',
                            mascot: 'Shermans',
                            address1: '14193 Pleasant Valley Road',
                            city: 'Chillicothe',
                            state: 'OH',
                            zip: '45601',
                            logo_location: 'logos/Unioto.png'
                          }
                        ])

games = Game.create([
                      {
                        sport: 'Football',
                        gender: 'Boys',
                        level: 'Varsity',
                        home_team_id: 1,
                        visiting_team_id: 2,
                        max_capacity: '1000',
                        location: 'Paint Valley High School',
                        extra_details: '50/50 raffle to support the PV ROTC program sold throughout the game! Winner drawn in 3rd quarter.',
                        event_start: DateTime.new(2021, 9, 1, 19, 30),
                        price: 500
                      },

                      {
                        sport: 'Football',
                        gender: 'Boys',
                        level: 'Varsity',
                        home_team_id: 1,
                        visiting_team_id: 3,
                        max_capacity: '1000',
                        location: 'Paint Valley High School',
                        extra_details: 'Black out the Redstreaks! Wear all black to support our Bearcats!',
                        event_start: DateTime.new(2021, 9, 8, 15, 15),
                        price: 500
                      },
                      {
                        sport: 'Volleyball',
                        gender: 'Girls',
                        level: 'JV',
                        home_team_id: 1,
                        visiting_team_id: 4,
                        max_capacity: '270',
                        location: 'Paint Valley Middle School',
                        extra_details: 'Masks required at all times while spectating.',
                        event_start: DateTime.new(2021, 9, 5, 8, 45),
                        price: 700
                      },
                      {
                        sport: 'Baseball',
                        gender: 'Boys',
                        level: 'Varsity',
                        home_team_id: 1,
                        visiting_team_id: 2,
                        max_capacity: '500',
                        location: 'Paint Valley High School',
                        extra_details: "Tonight's sponsor is McDonald's of Chillicothe!",
                        event_start: DateTime.new(2020, 4, 5, 5, 30),
                        price: 500
                      }
                    ])

users = User.create([
                      {
                        first_name: 'Greatest',
                        last_name: 'Ever',
                        home_team_id: 1,
                        admin: true,
                        email: 'my@email.com',
                        password: 'password1',
                        created_at: DateTime.new(2021, 1, 7),
                        updated_at: DateTime.new(2021, 1, 7),
                        confirmation_token: 'xyz321',
                        confirmed_at: DateTime.new(2021, 1, 10),
                        confirmation_sent_at: DateTime.new(2021, 1, 9)
                      },
                      {
                        first_name: 'Jeorge',
                        last_name: 'Simpilton',
                        home_team_id: 1,
                        admin: false,
                        email: 'jeo@email.com',
                        password: 'pas3wrid',
                        created_at: DateTime.new(2021, 1, 7),
                        updated_at: DateTime.new(2021, 1, 7),
                        confirmation_token: 'abc123',
                        confirmed_at: DateTime.new(2021, 1, 10),
                        confirmation_sent_at: DateTime.new(2021, 1, 9)
                      }
                    ])

tickets = Ticket.create([
                          {
                            game: games.first,
                            user: users.first,
                            used: false
                          },
                          {
                            game: games.first,
                            user: users.second,
                            used: false
                          }
                        ])
