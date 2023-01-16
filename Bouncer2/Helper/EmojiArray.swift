//
//  EmojiArray.swift
//  Bouncer2
//
//  Created by Andrew Kestler on 9/22/22.
//

import Foundation


struct Emoji: Hashable, Codable{
    static func == (lhs: Emoji, rhs: Emoji) -> Bool {
        lhs.name == rhs.name
    }
    let name: String
    let emote: String
}

struct EmojiGallery{
    
var people = """
😀 Grinning Face
😃 Grinning Face with Big Eyes
😄 Grinning Face with Smiling Eyes
😁 Beaming Face with Smiling Eyes
😆 Grinning Squinting Face
😅 Grinning Face with Sweat
🤣 Rolling on the Floor Laughing
😂 Face with Tears of Joy
🙂 Slightly Smiling Face
🙃 Upside-Down Face
🫠 Melting Face
😉 Winking Face
😊 Smiling Face with Smiling Eyes
😇 Smiling Face with Halo
🥰 Smiling Face with Hearts
😍 Smiling Face with Heart-Eyes
🤩 Star-Struck
😘 Face Blowing a Kiss
😗 Kissing Face
☺️ Smiling Face
😚 Kissing Face with Closed Eyes
😙 Kissing Face with Smiling Eyes
🥲 Smiling Face with Tear
😋 Face Savoring Food
😛 Face with Tongue
😜 Winking Face with Tongue
🤪 Zany Face
😝 Squinting Face with Tongue
🤑 Money-Mouth Face
🤗 Smiling Face with Open Hands
🤭 Face with Hand Over Mouth
🫢 Face with Open Eyes and Hand Over Mouth
🫣 Face with Peeking Eye
🤫 Shushing Face
🤔 Thinking Face
🫡 Saluting Face
🤐 Zipper-Mouth Face
🤨 Face with Raised Eyebrow
😐 Neutral Face
😑 Expressionless Face
😶 Face Without Mouth
🫥 Dotted Line Face
😶‍🌫️ Face in Clouds
😏 Smirking Face
😒 Unamused Face
🙄 Face with Rolling Eyes
😬 Grimacing Face
😮‍💨 Face Exhaling
🤥 Lying Face
😌 Relieved Face
😔 Pensive Face
😪 Sleepy Face
🤤 Drooling Face
😴 Sleeping Face
😷 Face with Medical Mask
🤒 Face with Thermometer
🤕 Face with Head-Bandage
🤢 Nauseated Face
🤮 Face Vomiting
🤧 Sneezing Face
🥵 Hot Face
🥶 Cold Face
🥴 Woozy Face
😵 Face with Crossed-Out Eyes
😵‍💫 Face with Spiral Eyes
🤯 Exploding Head
🤠 Cowboy Hat Face
🥳 Partying Face
🥸 Disguised Face
😎 Smiling Face with Sunglasses
🤓 Nerd Face
🧐 Face with Monocle
😕 Confused Face
🫤 Face with Diagonal Mouth
😟 Worried Face
🙁 Slightly Frowning Face
☹️ Frowning Face
😮 Face with Open Mouth
😯 Hushed Face
😲 Astonished Face
😳 Flushed Face
🥺 Pleading Face
🥹 Face Holding Back Tears
😦 Frowning Face with Open Mouth
😧 Anguished Face
😨 Fearful Face
😰 Anxious Face with Sweat
😥 Sad but Relieved Face
😢 Crying Face
😭 Loudly Crying Face
😱 Face Screaming in Fear
😖 Confounded Face
😣 Persevering Face
😞 Disappointed Face
😓 Downcast Face with Sweat
😩 Weary Face
😫 Tired Face
🥱 Yawning Face
😤 Face with Steam From Nose
😡 Enraged Face
😠 Angry Face
🤬 Face with Symbols on Mouth
😈 Smiling Face with Horns
👿 Angry Face with Horns
💀 Skull
☠️ Skull and Crossbones
💩 Pile of Poo
🤡 Clown Face
👹 Ogre
👺 Goblin
👻 Ghost
👽 Alien
👾 Alien Monster
🤖 Robot
😺 Grinning Cat
😸 Grinning Cat with Smiling Eyes
😹 Cat with Tears of Joy
😻 Smiling Cat with Heart-Eyes
😼 Cat with Wry Smile
😽 Kissing Cat
🙀 Weary Cat
😿 Crying Cat
😾 Pouting Cat
💋 Kiss Mark
👋 Waving Hand
🤚 Raised Back of Hand
🖐️ Hand with Fingers Splayed
✋ Raised Hand
🖖 Vulcan Salute
🫱 Rightwards Hand
🫲 Leftwards Hand
🫳 Palm Down Hand
🫴 Palm Up Hand
👌 OK Hand
🤌 Pinched Fingers
🤏 Pinching Hand
✌️ Victory Hand
🤞 Crossed Fingers
🫰 Hand with Index Finger and Thumb Crossed
🤟 Love-You Gesture
🤘 Sign of the Horns
🤙 Call Me Hand
👈 Backhand Index Pointing Left
👉 Backhand Index Pointing Right
👆 Backhand Index Pointing Up
🖕 Middle Finger
👇 Backhand Index Pointing Down
☝️ Index Pointing Up
🫵 Index Pointing at the Viewer
👍 Thumbs Up
👎 Thumbs Down
✊ Raised Fist
👊 Oncoming Fist
🤛 Left-Facing Fist
🤜 Right-Facing Fist
👏 Clapping Hands
🙌 Raising Hands
🫶 Heart Hands
👐 Open Hands
🤲 Palms Up Together
🤝 Handshake
🙏 Folded Hands
✍️ Writing Hand
💅 Nail Polish
🤳 Selfie
💪 Flexed Biceps
🦾 Mechanical Arm
🦿 Mechanical Leg
🦵 Leg
🦶 Foot
👂 Ear
🦻 Ear with Hearing Aid
👃 Nose
🧠 Brain
🫀 Anatomical Heart
🫁 Lungs
🦷 Tooth
🦴 Bone
👀 Eyes
👁️ Eye
👅 Tongue
👄 Mouth
🫦 Biting Lip
👶 Baby
🧒 Child
👦 Boy
👧 Girl
🧑 Person
👱 Person: Blond Hair
👨 Man
🧔 Person: Beard
👨‍🦰 Man: Red Hair
👨‍🦱 Man: Curly Hair
👨‍🦳 Man: White Hair
👨‍🦲 Man: Bald
👩 Woman
👩‍🦰 Woman: Red Hair
🧑‍🦰 Person: Red Hair
👩‍🦱 Woman: Curly Hair
🧑‍🦱 Person: Curly Hair
👩‍🦳 Woman: White Hair
🧑‍🦳 Person: White Hair
👩‍🦲 Woman: Bald
🧑‍🦲 Person: Bald
👱‍♀️ Woman: Blond Hair
👱‍♂️ Man: Blond Hair
🧓 Older Person
👴 Old Man
👵 Old Woman
🙍 Person Frowning
🙍‍♂️ Man Frowning
🙍‍♀️ Woman Frowning
🙎 Person Pouting
🙎‍♂️ Man Pouting
🙎‍♀️ Woman Pouting
🙅 Person Gesturing No
🙅‍♂️ Man Gesturing No
🙅‍♀️ Woman Gesturing No
🙆 Person Gesturing OK
🙆‍♂️ Man Gesturing OK
🙆‍♀️ Woman Gesturing OK
💁 Person Tipping Hand
💁‍♂️ Man Tipping Hand
💁‍♀️ Woman Tipping Hand
🙋 Person Raising Hand
🙋‍♂️ Man Raising Hand
🙋‍♀️ Woman Raising Hand
🧏 Deaf Person
🧏‍♂️ Deaf Man
🧏‍♀️ Deaf Woman
🙇 Person Bowing
🙇‍♂️ Man Bowing
🙇‍♀️ Woman Bowing
🤦 Person Facepalming
🤦‍♂️ Man Facepalming
🤦‍♀️ Woman Facepalming
🤷 Person Shrugging
🤷‍♂️ Man Shrugging
🤷‍♀️ Woman Shrugging
🧑‍⚕️ Health Worker
👨‍⚕️ Man Health Worker
👩‍⚕️ Woman Health Worker
🧑‍🎓 Student
👨‍🎓 Man Student
👩‍🎓 Woman Student
🧑‍🏫 Teacher
👨‍🏫 Man Teacher
👩‍🏫 Woman Teacher
🧑‍⚖️ Judge
👨‍⚖️ Man Judge
👩‍⚖️ Woman Judge
🧑‍🌾 Farmer
👨‍🌾 Man Farmer
👩‍🌾 Woman Farmer
🧑‍🍳 Cook
👨‍🍳 Man Cook
👩‍🍳 Woman Cook
🧑‍🔧 Mechanic
👨‍🔧 Man Mechanic
👩‍🔧 Woman Mechanic
🧑‍🏭 Factory Worker
👨‍🏭 Man Factory Worker
👩‍🏭 Woman Factory Worker
🧑‍💼 Office Worker
👨‍💼 Man Office Worker
👩‍💼 Woman Office Worker
🧑‍🔬 Scientist
👨‍🔬 Man Scientist
👩‍🔬 Woman Scientist
🧑‍💻 Technologist
👨‍💻 Man Technologist
👩‍💻 Woman Technologist
🧑‍🎤 Singer
👨‍🎤 Man Singer
👩‍🎤 Woman Singer
🧑‍🎨 Artist
👨‍🎨 Man Artist
👩‍🎨 Woman Artist
🧑‍✈️ Pilot
👨‍✈️ Man Pilot
👩‍✈️ Woman Pilot
🧑‍🚀 Astronaut
👨‍🚀 Man Astronaut
👩‍🚀 Woman Astronaut
🧑‍🚒 Firefighter
👨‍🚒 Man Firefighter
👩‍🚒 Woman Firefighter
👮 Police Officer
👮‍♂️ Man Police Officer
👮‍♀️ Woman Police Officer
🕵️ Detective
🕵️‍♂️ Man Detective
🕵️‍♀️ Woman Detective
💂 Guard
💂‍♂️ Man Guard
💂‍♀️ Woman Guard
🥷 Ninja
👷 Construction Worker
👷‍♂️ Man Construction Worker
👷‍♀️ Woman Construction Worker
🫅 Person with Crown
🤴 Prince
👸 Princess
👳 Person Wearing Turban
👳‍♂️ Man Wearing Turban
👳‍♀️ Woman Wearing Turban
👲 Person with Skullcap
🧕 Woman with Headscarf
🤵 Person in Tuxedo
🤵‍♂️ Man in Tuxedo
🤵‍♀️ Woman in Tuxedo
👰 Person with Veil
👰‍♂️ Man with Veil
👰‍♀️ Woman with Veil
🤰 Pregnant Woman
🫃 Pregnant Man
🫄 Pregnant Person
🤱 Breast-Feeding
👩‍🍼 Woman Feeding Baby
👨‍🍼 Man Feeding Baby
🧑‍🍼 Person Feeding Baby
👼 Baby Angel
🎅 Santa Claus
🤶 Mrs. Claus
🧑‍🎄 Mx Claus
🦸 Superhero
🦸‍♂️ Man Superhero
🦸‍♀️ Woman Superhero
🦹 Supervillain
🦹‍♂️ Man Supervillain
🦹‍♀️ Woman Supervillain
🧙 Mage
🧙‍♂️ Man Mage
🧙‍♀️ Woman Mage
🧚 Fairy
🧚‍♂️ Man Fairy
🧚‍♀️ Woman Fairy
🧛 Vampire
🧛‍♂️ Man Vampire
🧛‍♀️ Woman Vampire
🧜 Merperson
🧜‍♂️ Merman
🧜‍♀️ Mermaid
🧝 Elf
🧝‍♂️ Man Elf
🧝‍♀️ Woman Elf
🧞 Genie
🧞‍♂️ Man Genie
🧞‍♀️ Woman Genie
🧟 Zombie
🧟‍♂️ Man Zombie
🧟‍♀️ Woman Zombie
🧌 Troll
💆 Person Getting Massage
💆‍♂️ Man Getting Massage
💆‍♀️ Woman Getting Massage
💇 Person Getting Haircut
💇‍♂️ Man Getting Haircut
💇‍♀️ Woman Getting Haircut
🚶 Person Walking
🚶‍♂️ Man Walking
🚶‍♀️ Woman Walking
🧍 Person Standing
🧍‍♂️ Man Standing
🧍‍♀️ Woman Standing
🧎 Person Kneeling
🧎‍♂️ Man Kneeling
🧎‍♀️ Woman Kneeling
🧑‍🦯 Person with White Cane
👨‍🦯 Man with White Cane
👩‍🦯 Woman with White Cane
🧑‍🦼 Person in Motorized Wheelchair
👨‍🦼 Man in Motorized Wheelchair
👩‍🦼 Woman in Motorized Wheelchair
🧑‍🦽 Person in Manual Wheelchair
👨‍🦽 Man in Manual Wheelchair
👩‍🦽 Woman in Manual Wheelchair
🏃 Person Running
🏃‍♂️ Man Running
🏃‍♀️ Woman Running
💃 Woman Dancing
🕺 Man Dancing
🕴️ Person in Suit Levitating
👯 People with Bunny Ears
👯‍♂️ Men with Bunny Ears
👯‍♀️ Women with Bunny Ears
🧖 Person in Steamy Room
🧖‍♂️ Man in Steamy Room
🧖‍♀️ Woman in Steamy Room
🧘 Person in Lotus Position
🧑‍🤝‍🧑 People Holding Hands
👭 Women Holding Hands
👫 Woman and Man Holding Hands
👬 Men Holding Hands
💏 Kiss
👩‍❤️‍💋‍👨 Kiss: Woman, Man
👨‍❤️‍💋‍👨 Kiss: Man, Man
👩‍❤️‍💋‍👩 Kiss: Woman, Woman
💑 Couple with Heart
👩‍❤️‍👨 Couple with Heart: Woman, Man
👨‍❤️‍👨 Couple with Heart: Man, Man
👩‍❤️‍👩 Couple with Heart: Woman, Woman
👪 Family
👨‍👩‍👦 Family: Man, Woman, Boy
👨‍👩‍👧 Family: Man, Woman, Girl
👨‍👩‍👧‍👦 Family: Man, Woman, Girl, Boy
👨‍👩‍👦‍👦 Family: Man, Woman, Boy, Boy
👨‍👩‍👧‍👧 Family: Man, Woman, Girl, Girl
👨‍👨‍👦 Family: Man, Man, Boy
👨‍👨‍👧 Family: Man, Man, Girl
👨‍👨‍👧‍👦 Family: Man, Man, Girl, Boy
👨‍👨‍👦‍👦 Family: Man, Man, Boy, Boy
👨‍👨‍👧‍👧 Family: Man, Man, Girl, Girl
👩‍👩‍👦 Family: Woman, Woman, Boy
👩‍👩‍👧 Family: Woman, Woman, Girl
👩‍👩‍👧‍👦 Family: Woman, Woman, Girl, Boy
👩‍👩‍👦‍👦 Family: Woman, Woman, Boy, Boy
👩‍👩‍👧‍👧 Family: Woman, Woman, Girl, Girl
👨‍👦 Family: Man, Boy
👨‍👦‍👦 Family: Man, Boy, Boy
👨‍👧 Family: Man, Girl
👨‍👧‍👦 Family: Man, Girl, Boy
👨‍👧‍👧 Family: Man, Girl, Girl
👩‍👦 Family: Woman, Boy
👩‍👦‍👦 Family: Woman, Boy, Boy
👩‍👧 Family: Woman, Girl
👩‍👧‍👦 Family: Woman, Girl, Boy
👩‍👧‍👧 Family: Woman, Girl, Girl
🗣️ Speaking Head
👤 Bust in Silhouette
👥 Busts in Silhouette
🫂 People Hugging
👣 Footprints
🧳 Luggage
🌂 Closed Umbrella
☂️ Umbrella
🎃 Jack-O-Lantern
🧵 Thread
👓 Glasses
🕶️ Sunglasses
🥽 Goggles
🥼 Lab Coat
🦺 Safety Vest
👔 Necktie
👕 T-Shirt
👖 Jeans
🧣 Scarf
🧤 Gloves
🧥 Coat
🧦 Socks
👗 Dress
👘 Kimono
🥻 Sari
🩱 One-Piece Swimsuit
🩲 Briefs
🩳 Shorts
👙 Bikini
👚 Woman’s Clothes
👛 Purse
👜 Handbag
👝 Clutch Bag
🎒 Backpack
🩴 Thong Sandal
👞 Man’s Shoe
👟 Running Shoe
🥾 Hiking Boot
🥿 Flat Shoe
👠 High-Heeled Shoe
👡 Woman’s Sandal
🩰 Ballet Shoes
👢 Woman’s Boot
👑 Crown
👒 Woman’s Hat
🎩 Top Hat
🎓 Graduation Cap
🧢 Billed Cap
🪖 Military Helmet
⛑️ Rescue Worker’s Helmet
💄 Lipstick
💍 Ring
💼 Briefcase
🩸 Drop of Blood
🙈 See-No-Evil Monkey
🙉 Hear-No-Evil Monkey
🙊 Speak-No-Evil Monkey
💥 Collision
💫 Dizzy
💦 Sweat Droplets
💨 Dashing Away
🐵 Monkey Face
🐒 Monkey
🦍 Gorilla
🦧 Orangutan
🐶 Dog Face
🐕 Dog
🦮 Guide Dog
🐕‍🦺 Service Dog
🐩 Poodle
🐺 Wolf
🦊 Fox
🦝 Raccoon
🐱 Cat Face
🐈 Cat
🐈‍⬛ Black Cat
🦁 Lion
🐯 Tiger Face
🐅 Tiger
🐆 Leopard
🐴 Horse Face
🐎 Horse
🦄 Unicorn
🦓 Zebra
🦌 Deer
🦬 Bison
🐮 Cow Face
🐂 Ox
🐃 Water Buffalo
🐄 Cow
🐷 Pig Face
🐖 Pig
🐗 Boar
🐽 Pig Nose
🐏 Ram
🐑 Ewe
🐐 Goat
🐪 Camel
🐫 Two-Hump Camel
🦙 Llama
🦒 Giraffe
🐘 Elephant
🦣 Mammoth
🦏 Rhinoceros
🦛 Hippopotamus
🐭 Mouse Face
🐁 Mouse
🐀 Rat
🐹 Hamster
🐰 Rabbit Face
🐇 Rabbit
🐿️ Chipmunk
🦫 Beaver
🦔 Hedgehog
🦇 Bat
🐻 Bear
🐻‍❄️ Polar Bear
🐨 Koala
🐼 Panda
🦥 Sloth
🦦 Otter
🦨 Skunk
🦘 Kangaroo
🦡 Badger
🐾 Paw Prints
🦃 Turkey
🐔 Chicken
🐓 Rooster
🐣 Hatching Chick
🐤 Baby Chick
🐥 Front-Facing Baby Chick
🐦 Bird
🐧 Penguin
🕊️ Dove
🦅 Eagle
🦆 Duck
🦢 Swan
🦉 Owl
🦤 Dodo
🪶 Feather
🦩 Flamingo
🦚 Peacock
🦜 Parrot
🐸 Frog
🐊 Crocodile
🐢 Turtle
🦎 Lizard
🐍 Snake
🐲 Dragon Face
🐉 Dragon
🦕 Sauropod
🦖 T-Rex
🐳 Spouting Whale
🐋 Whale
🐬 Dolphin
🦭 Seal
🐟 Fish
🐠 Tropical Fish
🐡 Blowfish
🦈 Shark
🐙 Octopus
🐚 Spiral Shell
🪸 Coral
🐌 Snail
🦋 Butterfly
🐛 Bug
🐜 Ant
🐝 Honeybee
🪲 Beetle
🐞 Lady Beetle
🦗 Cricket
🪳 Cockroach
🕷️ Spider
🕸️ Spider Web
🦂 Scorpion
🦟 Mosquito
🪰 Fly
🪱 Worm
🦠 Microbe
💐 Bouquet
🌸 Cherry Blossom
💮 White Flower
🪷 Lotus
🏵️ Rosette
🌹 Rose
🥀 Wilted Flower
🌺 Hibiscus
🌻 Sunflower
🌼 Blossom
🌷 Tulip
🌱 Seedling
🪴 Potted Plant
🌲 Evergreen Tree
🌳 Deciduous Tree
🌴 Palm Tree
🌵 Cactus
🌾 Sheaf of Rice
🌿 Herb
☘️ Shamrock
🍀 Four Leaf Clover
🍁 Maple Leaf
🍂 Fallen Leaf
🍃 Leaf Fluttering in Wind
🪹 Empty Nest
🪺 Nest with Eggs
🍄 Mushroom
🌰 Chestnut
🦀 Crab
🦞 Lobster
🦐 Shrimp
🦑 Squid
🌍 Globe Showing Europe-Africa
🌎 Globe Showing Americas
🌏 Globe Showing Asia-Australia
🌐 Globe with Meridians
🪨 Rock
🌑 New Moon
🌒 Waxing Crescent Moon
🌓 First Quarter Moon
🌔 Waxing Gibbous Moon
🌕 Full Moon
🌖 Waning Gibbous Moon
🌗 Last Quarter Moon
🌘 Waning Crescent Moon
🌙 Crescent Moon
🌚 New Moon Face
🌛 First Quarter Moon Face
🌜 Last Quarter Moon Face
☀️ Sun
🌝 Full Moon Face
🌞 Sun with Face
⭐ Star
🌟 Glowing Star
🌠 Shooting Star
☁️ Cloud
⛅ Sun Behind Cloud
⛈️ Cloud with Lightning and Rain
🌤️ Sun Behind Small Cloud
🌥️ Sun Behind Large Cloud
🌦️ Sun Behind Rain Cloud
🌧️ Cloud with Rain
🌨️ Cloud with Snow
🌩️ Cloud with Lightning
🌪️ Tornado
🌫️ Fog
🌬️ Wind Face
🌈 Rainbow
☔ Umbrella with Rain Drops
⚡ High Voltage
❄️ Snowflake
☃️ Snowman
⛄ Snowman Without Snow
☄️ Comet
🔥 Fire
💧 Droplet
🌊 Water Wave
🎄 Christmas Tree
✨ Sparkles
🎋 Tanabata Tree
🎍 Pine Decoration
🫧 Bubbles
🍇 Grapes
🍈 Melon
🍉 Watermelon
🍊 Tangerine
🍋 Lemon
🍌 Banana
🍍 Pineapple
🥭 Mango
🍎 Red Apple
🍏 Green Apple
🍐 Pear
🍑 Peach
🍒 Cherries
🍓 Strawberry
🫐 Blueberries
🥝 Kiwi Fruit
🍅 Tomato
🫒 Olive
🥥 Coconut
🥑 Avocado
🍆 Eggplant
🥔 Potato
🥕 Carrot
🌽 Ear of Corn
🌶️ Hot Pepper
🫑 Bell Pepper
🥒 Cucumber
🥬 Leafy Green
🥦 Broccoli
🧄 Garlic
🧅 Onion
🍄 Mushroom
🥜 Peanuts
🫘 Beans
🌰 Chestnut
🍞 Bread
🥐 Croissant
🥖 Baguette Bread
🫓 Flatbread
🥨 Pretzel
🥯 Bagel
🥞 Pancakes
🧇 Waffle
🧀 Cheese Wedge
🍖 Meat on Bone
🍗 Poultry Leg
🥩 Cut of Meat
🥓 Bacon
🍔 Hamburger
🍟 French Fries
🍕 Pizza
🌭 Hot Dog
🥪 Sandwich
🌮 Taco
🌯 Burrito
🫔 Tamale
🥙 Stuffed Flatbread
🧆 Falafel
🥚 Egg
🍳 Cooking
🥘 Shallow Pan of Food
🍲 Pot of Food
🫕 Fondue
🥣 Bowl with Spoon
🥗 Green Salad
🍿 Popcorn
🧈 Butter
🧂 Salt
🥫 Canned Food
🍱 Bento Box
🍘 Rice Cracker
🍙 Rice Ball
🍚 Cooked Rice
🍛 Curry Rice
🍜 Steaming Bowl
🍝 Spaghetti
🍠 Roasted Sweet Potato
🍢 Oden
🍣 Sushi
🍤 Fried Shrimp
🍥 Fish Cake with Swirl
🥮 Moon Cake
🍡 Dango
🥟 Dumpling
🥠 Fortune Cookie
🥡 Takeout Box
🦪 Oyster
🍦 Soft Ice Cream
🍧 Shaved Ice
🍨 Ice Cream
🍩 Doughnut
🍪 Cookie
🎂 Birthday Cake
🍰 Shortcake
🧁 Cupcake
🥧 Pie
🍫 Chocolate Bar
🍬 Candy
🍭 Lollipop
🍮 Custard
🍯 Honey Pot
🍼 Baby Bottle
🥛 Glass of Milk
☕ Hot Beverage
🫖 Teapot
🍵 Teacup Without Handle
🍶 Sake
🍾 Bottle with Popping Cork
🍷 Wine Glass
🍸 Cocktail Glass
🍹 Tropical Drink
🍺 Beer Mug
🍻 Clinking Beer Mugs
🥂 Clinking Glasses
🥃 Tumbler Glass
🫗 Pouring Liquid
🥤 Cup with Straw
🧋 Bubble Tea
🧃 Beverage Box
🧉 Mate
🧊 Ice
🥢 Chopsticks
🍽️ Fork and Knife with Plate
🍴 Fork and Knife
🥄 Spoon
🫙 Jar
🕴️ Person in Suit Levitating
🧗 Person Climbing
🧗‍♂️ Man Climbing
🧗‍♀️ Woman Climbing
🤺 Person Fencing
🏇 Horse Racing
⛷️ Skier
🏂 Snowboarder
🏌️ Person Golfing
🏌️‍♂️ Man Golfing
🏌️‍♀️ Woman Golfing
🏄 Person Surfing
🏄‍♂️ Man Surfing
🏄‍♀️ Woman Surfing
🚣‍♂️ Man Rowing Boat
🚣‍♀️ Woman Rowing Boat
🏊 Person Swimming
🏊‍♂️ Man Swimming
🏊‍♀️ Woman Swimming
⛹️ Person Bouncing Ball
⛹️‍♂️ Man Bouncing Ball
⛹️‍♀️ Woman Bouncing Ball
🏋️ Person Lifting Weights
🏋️‍♂️ Man Lifting Weights
🏋️‍♀️ Woman Lifting Weights
🚴 Person Biking
🚴‍♂️ Man Biking
🚴‍♀️ Woman Biking
🚵 Person Mountain Biking
🚵‍♂️ Man Mountain Biking
🚵‍♀️ Woman Mountain Biking
🤸 Person Cartwheeling
🤸‍♂️ Man Cartwheeling
🤸‍♀️ Woman Cartwheeling
🤼 People Wrestling
🤼‍♂️ Men Wrestling
🤼‍♀️ Women Wrestling
🤽 Person Playing Water Polo
🤽‍♂️ Man Playing Water Polo
🤽‍♀️ Woman Playing Water Polo
🤾 Person Playing Handball
🤾‍♂️ Man Playing Handball
🤾‍♀️ Woman Playing Handball
🤹 Person Juggling
🤹‍♂️ Man Juggling
🤹‍♀️ Woman Juggling
🧘 Person in Lotus Position
🧘‍♂️ Man in Lotus Position
🧘‍♀️ Woman in Lotus Position
🎪 Circus Tent
🛹 Skateboard
🛼 Roller Skate
🛶 Canoe
🎗️ Reminder Ribbon
🎟️ Admission Tickets
🎫 Ticket
🎖️ Military Medal
🏆 Trophy
🏅 Sports Medal
🥇 1st Place Medal
🥈 2nd Place Medal
🥉 3rd Place Medal
⚽ Soccer Ball
⚾ Baseball
🥎 Softball
🏀 Basketball
🏐 Volleyball
🏈 American Football
🏉 Rugby Football
🎾 Tennis
🥏 Flying Disc
🎳 Bowling
🏏 Cricket Game
🏑 Field Hockey
🏒 Ice Hockey
🥍 Lacrosse
🏓 Ping Pong
🏸 Badminton
🥊 Boxing Glove
🥋 Martial Arts Uniform
🥅 Goal Net
⛳ Flag in Hole
⛸️ Ice Skate
🎣 Fishing Pole
🎽 Running Shirt
🎿 Skis
🛷 Sled
🥌 Curling Stone
🎯 Bullseye
🎱 Pool 8 Ball
🎮 Video Game
🎰 Slot Machine
🎲 Game Die
🧩 Puzzle Piece
🪩 Mirror Ball
♟️ Chess Pawn
🎭 Performing Arts
🎨 Artist Palette
🧶 Yarn
🎼 Musical Score
🎤 Microphone
🎧 Headphone
🎷 Saxophone
🪗 Accordion
🎸 Guitar
🎹 Musical Keyboard
🎺 Trumpet
🎻 Violin
🥁 Drum
🪘 Long Drum
🎬 Clapper Board
🏹 Bow and Arrow
🚣 Person Rowing Boat
🗾 Map of Japan
🏔️ Snow-Capped Mountain
⛰️ Mountain
🌋 Volcano
🗻 Mount Fuji
🏕️ Camping
🏖️ Beach with Umbrella
🏜️ Desert
🏝️ Desert Island
🏞️ National Park
🏟️ Stadium
🏛️ Classical Building
🏗️ Building Construction
🛖 Hut
🏘️ Houses
🏚️ Derelict House
🏠 House
🏡 House with Garden
🏢 Office Building
🏣 Japanese Post Office
🏤 Post Office
🏥 Hospital
🏦 Bank
🏨 Hotel
🏩 Love Hotel
🏪 Convenience Store
🏫 School
🏬 Department Store
🏭 Factory
🏯 Japanese Castle
🏰 Castle
💒 Wedding
🗼 Tokyo Tower
🗽 Statue of Liberty
⛪ Church
🕌 Mosque
🛕 Hindu Temple
🕍 Synagogue
⛩️ Shinto Shrine
🕋 Kaaba
⛲ Fountain
⛺ Tent
🌁 Foggy
🌃 Night with Stars
🏙️ Cityscape
🌄 Sunrise Over Mountains
🌅 Sunrise
🌆 Cityscape at Dusk
🌇 Sunset
🌉 Bridge at Night
🎠 Carousel Horse
🛝 Playground Slide
🎡 Ferris Wheel
🎢 Roller Coaster
🚂 Locomotive
🚃 Railway Car
🚄 High-Speed Train
🚅 Bullet Train
🚆 Train
🚇 Metro
🚈 Light Rail
🚉 Station
🚊 Tram
🚝 Monorail
🚞 Mountain Railway
🚋 Tram Car
🚌 Bus
🚍 Oncoming Bus
🚎 Trolleybus
🚐 Minibus
🚑 Ambulance
🚒 Fire Engine
🚓 Police Car
🚔 Oncoming Police Car
🚕 Taxi
🚖 Oncoming Taxi
🚗 Automobile
🚘 Oncoming Automobile
🚙 Sport Utility Vehicle
🛻 Pickup Truck
🚚 Delivery Truck
🚛 Articulated Lorry
🚜 Tractor
🏎️ Racing Car
🏍️ Motorcycle
🛵 Motor Scooter
🛺 Auto Rickshaw
🚲 Bicycle
🛴 Kick Scooter
🚏 Bus Stop
🛣️ Motorway
🛤️ Railway Track
⛽ Fuel Pump
🛞 Wheel
🚨 Police Car Light
🚥 Horizontal Traffic Light
🚦 Vertical Traffic Light
🚧 Construction
⚓ Anchor
🛟 Ring Buoy
⛵ Sailboat
🚤 Speedboat
🛳️ Passenger Ship
⛴️ Ferry
🛥️ Motor Boat
🚢 Ship
✈️ Airplane
🛩️ Small Airplane
🛫 Airplane Departure
🛬 Airplane Arrival
🪂 Parachute
💺 Seat
🚁 Helicopter
🚟 Suspension Railway
🚠 Mountain Cableway
🚡 Aerial Tramway
🛰️ Satellite
🚀 Rocket
🛸 Flying Saucer
🪐 Ringed Planet
🌠 Shooting Star
🌌 Milky Way
🎆 Fireworks
🎇 Sparkler
🎑 Moon Viewing Ceremony
🛂 Passport Control
🛃 Customs
🛄 Baggage Claim
🛅 Left Luggage
💌 Love Letter
🕳️ Hole
💣 Bomb
🛀 Person Taking Bath
🛌 Person in Bed
🔪 Kitchen Knife
🏺 Amphora
🗺️ World Map
🧭 Compass
🧱 Brick
🦽 Manual Wheelchair
🦼 Motorized Wheelchair
🛢️ Oil Drum
🛎️ Bellhop Bell
🧳 Luggage
⌛ Hourglass Done
⏳ Hourglass Not Done
⌚ Watch
⏰ Alarm Clock
⏱️ Stopwatch
⏲️ Timer Clock
🕰️ Mantelpiece Clock
🌡️ Thermometer
⛱️ Umbrella on Ground
🧨 Firecracker
🎈 Balloon
🎉 Party Popper
🎊 Confetti Ball
🎎 Japanese Dolls
🎏 Carp Streamer
🎐 Wind Chime
🧧 Red Envelope
🎀 Ribbon
🎁 Wrapped Gift
🤿 Diving Mask
🪀 Yo-Yo
🪁 Kite
🔮 Crystal Ball
🪄 Magic Wand
🧿 Nazar Amulet
🪬 Hamsa
🕹️ Joystick
🧸 Teddy Bear
🪅 Piñata
🪆 Nesting Dolls
🖼️ Framed Picture
🧵 Thread
🪡 Sewing Needle
🧶 Yarn
🪢 Knot
🛍️ Shopping Bags
📿 Prayer Beads
💎 Gem Stone
🎙️ Studio Microphone
🎚️ Level Slider
🎛️ Control Knobs
📻 Radio
🪕 Banjo
📱 Mobile Phone
📲 Mobile Phone with Arrow
☎️ Telephone
📞 Telephone Receiver
📟 Pager
📠 Fax Machine
🔋 Battery
🔌 Electric Plug
💻 Laptop
🖥️ Desktop Computer
🖨️ Printer
⌨️ Keyboard
🖱️ Computer Mouse
🖲️ Trackball
💽 Computer Disk
💾 Floppy Disk
💿 Optical Disk
📀 DVD
🧮 Abacus
🎥 Movie Camera
🎞️ Film Frames
📽️ Film Projector
📺 Television
📷 Camera
📸 Camera with Flash
📹 Video Camera
📼 Videocassette
🔍 Magnifying Glass Tilted Left
🔎 Magnifying Glass Tilted Right
🕯️ Candle
💡 Light Bulb
🔦 Flashlight
🏮 Red Paper Lantern
🪔 Diya Lamp
📔 Notebook with Decorative Cover
📕 Closed Book
📖 Open Book
📗 Green Book
📘 Blue Book
📙 Orange Book
📚 Books
📓 Notebook
📒 Ledger
📃 Page with Curl
📜 Scroll
📄 Page Facing Up
📰 Newspaper
🗞️ Rolled-Up Newspaper
📑 Bookmark Tabs
🔖 Bookmark
🏷️ Label
💰 Money Bag
🪙 Coin
💴 Yen Banknote
💵 Dollar Banknote
💶 Euro Banknote
💷 Pound Banknote
💸 Money with Wings
💳 Credit Card
🧾 Receipt
✉️ Envelope
📧 E-Mail
📨 Incoming Envelope
📩 Envelope with Arrow
📤 Outbox Tray
📥 Inbox Tray
📦 Package
📫 Closed Mailbox with Raised Flag
📪 Closed Mailbox with Lowered Flag
📬 Open Mailbox with Raised Flag
📭 Open Mailbox with Lowered Flag
📮 Postbox
🗳️ Ballot Box with Ballot
✏️ Pencil
✒️ Black Nib
🖋️ Fountain Pen
🖊️ Pen
🖌️ Paintbrush
🖍️ Crayon
📝 Memo
📁 File Folder
📂 Open File Folder
🗂️ Card Index Dividers
📅 Calendar
📆 Tear-Off Calendar
🗒️ Spiral Notepad
🗓️ Spiral Calendar
📇 Card Index
📈 Chart Increasing
📉 Chart Decreasing
📊 Bar Chart
📋 Clipboard
📌 Pushpin
📍 Round Pushpin
📎 Paperclip
🖇️ Linked Paperclips
📏 Straight Ruler
📐 Triangular Ruler
✂️ Scissors
🗃️ Card File Box
🗄️ File Cabinet
🗑️ Wastebasket
🔒 Locked
🔓 Unlocked
🔏 Locked with Pen
🔐 Locked with Key
🔑 Key
🗝️ Old Key
🔨 Hammer
🪓 Axe
⛏️ Pick
⚒️ Hammer and Pick
🛠️ Hammer and Wrench
🗡️ Dagger
⚔️ Crossed Swords
🔫 Water Pistol
🪃 Boomerang
🛡️ Shield
🪚 Carpentry Saw
🔧 Wrench
🪛 Screwdriver
🔩 Nut and Bolt
⚙️ Gear
🗜️ Clamp
⚖️ Balance Scale
🦯 White Cane
🔗 Link
⛓️ Chains
🪝 Hook
🧰 Toolbox
🧲 Magnet
🪜 Ladder
⚗️ Alembic
🧪 Test Tube
🧫 Petri Dish
🧬 DNA
🔬 Microscope
🔭 Telescope
📡 Satellite Antenna
💉 Syringe
🩸 Drop of Blood
💊 Pill
🩹 Adhesive Bandage
🩼 Crutch
🩺 Stethoscope
🚪 Door
🪞 Mirror
🪟 Window
🛏️ Bed
🛋️ Couch and Lamp
🪑 Chair
🚽 Toilet
🪠 Plunger
🚿 Shower
🛁 Bathtub
🪤 Mouse Trap
🪒 Razor
🧴 Lotion Bottle
🧷 Safety Pin
🧹 Broom
🧺 Basket
🧻 Roll of Paper
🪣 Bucket
🧼 Soap
🪥 Toothbrush
🧽 Sponge
🧯 Fire Extinguisher
🛒 Shopping Cart
🚬 Cigarette
⚰️ Coffin
🪦 Headstone
⚱️ Funeral Urn
🗿 Moai
🪧 Placard
🪪 Identification Card
🚰 Potable Water
💘 Heart with Arrow
💝 Heart with Ribbon
💖 Sparkling Heart
💗 Growing Heart
💓 Beating Heart
💞 Revolving Hearts
💕 Two Hearts
💟 Heart Decoration
❣️ Heart Exclamation
💔 Broken Heart
❤️‍🔥 Heart on Fire
❤️‍🩹 Mending Heart
❤️ Red Heart
🧡 Orange Heart
💛 Yellow Heart
💚 Green Heart
💙 Blue Heart
💜 Purple Heart
🤎 Brown Heart
🖤 Black Heart
🤍 White Heart
💯 Hundred Points
💢 Anger Symbol
💬 Speech Balloon
👁️‍🗨️ Eye in Speech Bubble
🗨️ Left Speech Bubble
🗯️ Right Anger Bubble
💭 Thought Balloon
💤 Zzz
💮 White Flower
♨️ Hot Springs
💈 Barber Pole
🛑 Stop Sign
🕛 Twelve O’Clock
🕧 Twelve-Thirty
🕐 One O’Clock
🕜 One-Thirty
🕑 Two O’Clock
🕝 Two-Thirty
🕒 Three O’Clock
🕞 Three-Thirty
🕓 Four O’Clock
🕟 Four-Thirty
🕔 Five O’Clock
🕠 Five-Thirty
🕕 Six O’Clock
🕡 Six-Thirty
🕖 Seven O’Clock
🕢 Seven-Thirty
🕗 Eight O’Clock
🕣 Eight-Thirty
🕘 Nine O’Clock
🕤 Nine-Thirty
🕙 Ten O’Clock
🕥 Ten-Thirty
🕚 Eleven O’Clock
🕦 Eleven-Thirty
🌀 Cyclone
♠️ Spade Suit
♥️ Heart Suit
♦️ Diamond Suit
♣️ Club Suit
🃏 Joker
🀄 Mahjong Red Dragon
🎴 Flower Playing Cards
🔇 Muted Speaker
🔈 Speaker Low Volume
🔉 Speaker Medium Volume
🔊 Speaker High Volume
📢 Loudspeaker
📣 Megaphone
📯 Postal Horn
🔔 Bell
🔕 Bell with Slash
🎵 Musical Note
🎶 Musical Notes
💹 Chart Increasing with Yen
🛗 Elevator
🏧 ATM Sign
🚮 Litter in Bin Sign
♿ Wheelchair Symbol
🚹 Men’s Room
🚺 Women’s Room
🚻 Restroom
🚼 Baby Symbol
🚾 Water Closet
⚠️ Warning
🚸 Children Crossing
⛔ No Entry
🚫 Prohibited
🚳 No Bicycles
🚭 No Smoking
🚯 No Littering
🚱 Non-Potable Water
🚷 No Pedestrians
📵 No Mobile Phones
🔞 No One Under Eighteen
☢️ Radioactive
☣️ Biohazard
⬆️ Up Arrow
↗️ Up-Right Arrow
➡️ Right Arrow
↘️ Down-Right Arrow
⬇️ Down Arrow
↙️ Down-Left Arrow
⬅️ Left Arrow
↖️ Up-Left Arrow
↕️ Up-Down Arrow
↔️ Left-Right Arrow
↩️ Right Arrow Curving Left
↪️ Left Arrow Curving Right
⤴️ Right Arrow Curving Up
⤵️ Right Arrow Curving Down
🔃 Clockwise Vertical Arrows
🔄 Counterclockwise Arrows Button
🔙 Back Arrow
🔚 End Arrow
🔛 On! Arrow
🔜 Soon Arrow
🔝 Top Arrow
🛐 Place of Worship
⚛️ Atom Symbol
🕉️ Om
✡️ Star of David
☸️ Wheel of Dharma
☯️ Yin Yang
✝️ Latin Cross
☦️ Orthodox Cross
☪️ Star and Crescent
☮️ Peace Symbol
🕎 Menorah
🔯 Dotted Six-Pointed Star
♈ Aries
♉ Taurus
♊ Gemini
♋ Cancer
♌ Leo
♍ Virgo
♎ Libra
♏ Scorpio
♐ Sagittarius
♑ Capricorn
♒ Aquarius
♓ Pisces
⛎ Ophiuchus
🔀 Shuffle Tracks Button
🔁 Repeat Button
🔂 Repeat Single Button
▶️ Play Button
⏩ Fast-Forward Button
⏭️ Next Track Button
⏯️ Play or Pause Button
◀️ Reverse Button
⏪ Fast Reverse Button
⏮️ Last Track Button
🔼 Upwards Button
⏫ Fast Up Button
🔽 Downwards Button
⏬ Fast Down Button
⏸️ Pause Button
⏹️ Stop Button
⏺️ Record Button
⏏️ Eject Button
🎦 Cinema
🔅 Dim Button
🔆 Bright Button
📶 Antenna Bars
📳 Vibration Mode
📴 Mobile Phone Off
♀️ Female Sign
♂️ Male Sign
✖️ Multiply
➕ Plus
➖ Minus
➗ Divide
🟰 Heavy Equals Sign
♾️ Infinity
‼️ Double Exclamation Mark
⁉️ Exclamation Question Mark
❓ Red Question Mark
❔ White Question Mark
❕ White Exclamation Mark
❗ Red Exclamation Mark
〰️ Wavy Dash
💱 Currency Exchange
💲 Heavy Dollar Sign
⚕️ Medical Symbol
♻️ Recycling Symbol
⚜️ Fleur-de-lis
🔱 Trident Emblem
📛 Name Badge
🔰 Japanese Symbol for Beginner
⭕ Hollow Red Circle
✅ Check Mark Button
☑️ Check Box with Check
✔️ Check Mark
❌ Cross Mark
❎ Cross Mark Button
➰ Curly Loop
➿ Double Curly Loop
〽️ Part Alternation Mark
✳️ Eight-Spoked Asterisk
✴️ Eight-Pointed Star
❇️ Sparkle
©️ Copyright
®️ Registered
™️ Trade Mark
#️⃣ Keycap Number Sign
*️⃣ Keycap Asterisk
0️⃣ Keycap Digit Zero
1️⃣ Keycap Digit One
2️⃣ Keycap Digit Two
3️⃣ Keycap Digit Three
4️⃣ Keycap Digit Four
5️⃣ Keycap Digit Five
6️⃣ Keycap Digit Six
7️⃣ Keycap Digit Seven
8️⃣ Keycap Digit Eight
9️⃣ Keycap Digit Nine
🔟 Keycap: 10
🔠 Input Latin Uppercase
🔡 Input Latin Lowercase
🔢 Input Numbers
🔣 Input Symbols
🔤 Input Latin Letters
🅰️ A Button (Blood Type)
🆎 AB Button (Blood Type)
🅱️ B Button (Blood Type)
🆑 CL Button
🆒 Cool Button
🆓 Free Button
ℹ️ Information
🆔 ID Button
Ⓜ️ Circled M
🆕 New Button
🆖 NG Button
🅾️ O Button (Blood Type)
🆗 OK Button
🅿️ P Button
🆘 SOS Button
🆙 Up! Button
🆚 Vs Button
🈁 Japanese “Here” Button
🈂️ Japanese “Service Charge” Button
🈷️ Japanese “Monthly Amount” Button
🈶 Japanese “Not Free of Charge” Button
🈯 Japanese “Reserved” Button
🉐 Japanese “Bargain” Button
🈹 Japanese “Discount” Button
🈚 Japanese “Free of Charge” Button
🈲 Japanese “Prohibited” Button
🉑 Japanese “Acceptable” Button
🈸 Japanese “Application” Button
🈴 Japanese “Passing Grade” Button
🈳 Japanese “Vacancy” Button
㊗️ Japanese “Congratulations” Button
㊙️ Japanese “Secret” Button
🈺 Japanese “Open for Business” Button
🈵 Japanese “No Vacancy” Button
🔴 Red Circle
🟠 Orange Circle
🟡 Yellow Circle
🟢 Green Circle
🔵 Blue Circle
🟣 Purple Circle
🟤 Brown Circle
⚫ Black Circle
⚪ White Circle
🟥 Red Square
🟧 Orange Square
🟨 Yellow Square
🟩 Green Square
🟦 Blue Square
🟪 Purple Square
🟫 Brown Square
⬛ Black Large Square
⬜ White Large Square
◼️ Black Medium Square
◻️ White Medium Square
◾ Black Medium-Small Square
◽ White Medium-Small Square
▪️ Black Small Square
▫️ White Small Square
🔶 Large Orange Diamond
🔷 Large Blue Diamond
🔸 Small Orange Diamond
🔹 Small Blue Diamond
🔺 Red Triangle Pointed Up
🔻 Red Triangle Pointed Down
💠 Diamond with a Dot
🔘 Radio Button
🔳 White Square Button
🔲 Black Square Button
🏁 Chequered Flag
🚩 Triangular Flag
🎌 Crossed Flags
🏴 Black Flag
🏳️ White Flag
🏳️‍🌈 Rainbow Flag
🏳️‍⚧️ Transgender Flag
🏴‍☠️ Pirate Flag
🇦🇨 Flag: Ascension Island
🇦🇩 Flag: Andorra
🇦🇪 Flag: United Arab Emirates
🇦🇫 Flag: Afghanistan
🇦🇬 Flag: Antigua & Barbuda
🇦🇮 Flag: Anguilla
🇦🇱 Flag: Albania
🇦🇲 Flag: Armenia
🇦🇴 Flag: Angola
🇦🇶 Flag: Antarctica
🇦🇷 Flag: Argentina
🇦🇸 Flag: American Samoa
🇦🇹 Flag: Austria
🇦🇺 Flag: Australia
🇦🇼 Flag: Aruba
🇦🇽 Flag: Åland Islands
🇦🇿 Flag: Azerbaijan
🇧🇦 Flag: Bosnia & Herzegovina
🇧🇧 Flag: Barbados
🇧🇩 Flag: Bangladesh
🇧🇪 Flag: Belgium
🇧🇫 Flag: Burkina Faso
🇧🇬 Flag: Bulgaria
🇧🇭 Flag: Bahrain
🇧🇮 Flag: Burundi
🇧🇯 Flag: Benin
🇧🇱 Flag: St. Barthélemy
🇧🇲 Flag: Bermuda
🇧🇳 Flag: Brunei
🇧🇴 Flag: Bolivia
🇧🇶 Flag: Caribbean Netherlands
🇧🇷 Flag: Brazil
🇧🇸 Flag: Bahamas
🇧🇹 Flag: Bhutan
🇧🇻 Flag: Bouvet Island
🇧🇼 Flag: Botswana
🇧🇾 Flag: Belarus
🇧🇿 Flag: Belize
🇨🇦 Flag: Canada
🇨🇨 Flag: Cocos (Keeling) Islands
🇨🇩 Flag: Congo - Kinshasa
🇨🇫 Flag: Central African Republic
🇨🇬 Flag: Congo - Brazzaville
🇨🇭 Flag: Switzerland
🇨🇮 Flag: Côte d’Ivoire
🇨🇰 Flag: Cook Islands
🇨🇱 Flag: Chile
🇨🇲 Flag: Cameroon
🇨🇳 Flag: China
🇨🇴 Flag: Colombia
🇨🇵 Flag: Clipperton Island
🇨🇷 Flag: Costa Rica
🇨🇺 Flag: Cuba
🇨🇻 Flag: Cape Verde
🇨🇼 Flag: Curaçao
🇨🇽 Flag: Christmas Island
🇨🇾 Flag: Cyprus
🇨🇿 Flag: Czechia
🇩🇪 Flag: Germany
🇩🇬 Flag: Diego Garcia
🇩🇯 Flag: Djibouti
🇩🇰 Flag: Denmark
🇩🇲 Flag: Dominica
🇩🇴 Flag: Dominican Republic
🇩🇿 Flag: Algeria
🇪🇦 Flag: Ceuta & Melilla
🇪🇨 Flag: Ecuador
🇪🇪 Flag: Estonia
🇪🇬 Flag: Egypt
🇪🇭 Flag: Western Sahara
🇪🇷 Flag: Eritrea
🇪🇸 Flag: Spain
🇪🇹 Flag: Ethiopia
🇪🇺 Flag: European Union
🇫🇮 Flag: Finland
🇫🇯 Flag: Fiji
🇫🇰 Flag: Falkland Islands
🇫🇲 Flag: Micronesia
🇫🇴 Flag: Faroe Islands
🇫🇷 Flag: France
🇬🇦 Flag: Gabon
🇬🇧 Flag: United Kingdom
🇬🇩 Flag: Grenada
🇬🇪 Flag: Georgia
🇬🇫 Flag: French Guiana
🇬🇬 Flag: Guernsey
🇬🇭 Flag: Ghana
🇬🇮 Flag: Gibraltar
🇬🇱 Flag: Greenland
🇬🇲 Flag: Gambia
🇬🇳 Flag: Guinea
🇬🇵 Flag: Guadeloupe
🇬🇶 Flag: Equatorial Guinea
🇬🇷 Flag: Greece
🇬🇸 Flag: South Georgia & South Sandwich Islands
🇬🇹 Flag: Guatemala
🇬🇺 Flag: Guam
🇬🇼 Flag: Guinea-Bissau
🇬🇾 Flag: Guyana
🇭🇰 Flag: Hong Kong SAR China
🇭🇲 Flag: Heard & McDonald Islands
🇭🇳 Flag: Honduras
🇭🇷 Flag: Croatia
🇭🇹 Flag: Haiti
🇭🇺 Flag: Hungary
🇮🇨 Flag: Canary Islands
🇮🇩 Flag: Indonesia
🇮🇪 Flag: Ireland
🇮🇱 Flag: Israel
🇮🇲 Flag: Isle of Man
🇮🇳 Flag: India
🇮🇴 Flag: British Indian Ocean Territory
🇮🇶 Flag: Iraq
🇮🇷 Flag: Iran
🇮🇸 Flag: Iceland
🇮🇹 Flag: Italy
🇯🇪 Flag: Jersey
🇯🇲 Flag: Jamaica
🇯🇴 Flag: Jordan
🇯🇵 Flag: Japan
🇰🇪 Flag: Kenya
🇰🇬 Flag: Kyrgyzstan
🇰🇭 Flag: Cambodia
🇰🇮 Flag: Kiribati
🇰🇲 Flag: Comoros
🇰🇳 Flag: St. Kitts & Nevis
🇰🇵 Flag: North Korea
🇰🇷 Flag: South Korea
🇰🇼 Flag: Kuwait
🇰🇾 Flag: Cayman Islands
🇰🇿 Flag: Kazakhstan
🇱🇦 Flag: Laos
🇱🇧 Flag: Lebanon
🇱🇨 Flag: St. Lucia
🇱🇮 Flag: Liechtenstein
🇱🇰 Flag: Sri Lanka
🇱🇷 Flag: Liberia
🇱🇸 Flag: Lesotho
🇱🇹 Flag: Lithuania
🇱🇺 Flag: Luxembourg
🇱🇻 Flag: Latvia
🇱🇾 Flag: Libya
🇲🇦 Flag: Morocco
🇲🇨 Flag: Monaco
🇲🇩 Flag: Moldova
🇲🇪 Flag: Montenegro
🇲🇫 Flag: St. Martin
🇲🇬 Flag: Madagascar
🇲🇭 Flag: Marshall Islands
🇲🇰 Flag: North Macedonia
🇲🇱 Flag: Mali
🇲🇲 Flag: Myanmar (Burma)
🇲🇳 Flag: Mongolia
🇲🇴 Flag: Macao Sar China
🇲🇵 Flag: Northern Mariana Islands
🇲🇶 Flag: Martinique
🇲🇷 Flag: Mauritania
🇲🇸 Flag: Montserrat
🇲🇹 Flag: Malta
🇲🇺 Flag: Mauritius
🇲🇻 Flag: Maldives
🇲🇼 Flag: Malawi
🇲🇽 Flag: Mexico
🇲🇾 Flag: Malaysia
🇲🇿 Flag: Mozambique
🇳🇦 Flag: Namibia
🇳🇨 Flag: New Caledonia
🇳🇪 Flag: Niger
🇳🇫 Flag: Norfolk Island
🇳🇬 Flag: Nigeria
🇳🇮 Flag: Nicaragua
🇳🇱 Flag: Netherlands
🇳🇴 Flag: Norway
🇳🇵 Flag: Nepal
🇳🇷 Flag: Nauru
🇳🇺 Flag: Niue
🇳🇿 Flag: New Zealand
🇴🇲 Flag: Oman
🇵🇦 Flag: Panama
🇵🇪 Flag: Peru
🇵🇫 Flag: French Polynesia
🇵🇬 Flag: Papua New Guinea
🇵🇭 Flag: Philippines
🇵🇰 Flag: Pakistan
🇵🇱 Flag: Poland
🇵🇲 Flag: St. Pierre & Miquelon
🇵🇳 Flag: Pitcairn Islands
🇵🇷 Flag: Puerto Rico
🇵🇸 Flag: Palestinian Territories
🇵🇹 Flag: Portugal
🇵🇼 Flag: Palau
🇵🇾 Flag: Paraguay
🇶🇦 Flag: Qatar
🇷🇪 Flag: Réunion
🇷🇴 Flag: Romania
🇷🇸 Flag: Serbia
🇷🇺 Flag: Russia
🇷🇼 Flag: Rwanda
🇸🇦 Flag: Saudi Arabia
🇸🇧 Flag: Solomon Islands
🇸🇨 Flag: Seychelles
🇸🇩 Flag: Sudan
🇸🇪 Flag: Sweden
🇸🇬 Flag: Singapore
🇸🇭 Flag: St. Helena
🇸🇮 Flag: Slovenia
🇸🇯 Flag: Svalbard & Jan Mayen
🇸🇰 Flag: Slovakia
🇸🇱 Flag: Sierra Leone
🇸🇲 Flag: San Marino
🇸🇳 Flag: Senegal
🇸🇴 Flag: Somalia
🇸🇷 Flag: Suriname
🇸🇸 Flag: South Sudan
🇸🇹 Flag: São Tomé & Príncipe
🇸🇻 Flag: El Salvador
🇸🇽 Flag: Sint Maarten
🇸🇾 Flag: Syria
🇸🇿 Flag: Eswatini
🇹🇦 Flag: Tristan Da Cunha
🇹🇨 Flag: Turks & Caicos Islands
🇹🇩 Flag: Chad
🇹🇫 Flag: French Southern Territories
🇹🇬 Flag: Togo
🇹🇭 Flag: Thailand
🇹🇯 Flag: Tajikistan
🇹🇰 Flag: Tokelau
🇹🇱 Flag: Timor-Leste
🇹🇲 Flag: Turkmenistan
🇹🇳 Flag: Tunisia
🇹🇴 Flag: Tonga
🇹🇷 Flag: Turkey
🇹🇹 Flag: Trinidad & Tobago
🇹🇻 Flag: Tuvalu
🇹🇼 Flag: Taiwan
🇹🇿 Flag: Tanzania
🇺🇦 Flag: Ukraine
🇺🇬 Flag: Uganda
🇺🇲 Flag: U.S. Outlying Islands
🇺🇳 Flag: United Nations
🇺🇸 Flag: United States
🇺🇾 Flag: Uruguay
🇺🇿 Flag: Uzbekistan
🇻🇦 Flag: Vatican City
🇻🇨 Flag: St. Vincent & Grenadines
🇻🇪 Flag: Venezuela
🇻🇬 Flag: British Virgin Islands
🇻🇮 Flag: U.S. Virgin Islands
🇻🇳 Flag: Vietnam
🇻🇺 Flag: Vanuatu
🇼🇫 Flag: Wallis & Futuna
🇼🇸 Flag: Samoa
🇽🇰 Flag: Kosovo
🇾🇪 Flag: Yemen
🇾🇹 Flag: Mayotte
🇿🇦 Flag: South Africa
🇿🇲 Flag: Zambia
🇿🇼 Flag: Zimbabwe
🏴󠁧󠁢󠁥󠁮󠁧󠁿 Flag: England
🏴󠁧󠁢󠁳󠁣󠁴󠁿 Flag: Scotland
🏴󠁧󠁢󠁷󠁬󠁳󠁿 Flag: Wales
"""

    static let shared = EmojiGallery()
    var emojis = [Emoji]()
    
    private init(){
        let arr = self.people.split(separator: "\n")
       
        for i in arr{
            
            let emote = String(i[i.startIndex])
            let name = String(i[i.index(i.startIndex, offsetBy: 2)..<i.endIndex])
            
            if !emojis.contains(Emoji(name: name, emote: emote)){
                emojis.append(Emoji(name: name, emote: emote))
            }
        }
    }
    
}

final class EmojiArray{
    
    static let shared = EmojiArray()
    
   private init(){
        
        all.append(contentsOf: EmojiArray.people)
        
        for i in EmojiArray.animalsNNature{
            if !all.contains(i){
                all.append(i)
            }
        }
        
        for i in EmojiArray.foodNDrink{
            if !all.contains(i){
                all.append(i)
            }
        }
        
        for i in EmojiArray.activity{
            if !all.contains(i){
                all.append(i)
            }
        }
        
        for i in EmojiArray.travelNPlaces{
            if !all.contains(i){
                all.append(i)
            }
        }
        
        for i in EmojiArray.objects{
            if !all.contains(i){
                all.append(i)
            }
        }
        
        for i in EmojiArray.symbols{
            if !all.contains(i){
                all.append(i)
            }
        }
        
        for i in EmojiArray.flags{
            if !all.contains(i){
                all.append(i)
            }
        }
        
//        people + animalsNNature + foodNDrink + activity + travelNPlaces + objects + symbols + flags
    }
    
    static let people = ["😀", "😃", "😄", "😁", "😆", "😅", "🤣", "😂", "🙂", "🙃", "🫠", "😉", "😊", "😇", "🥰", "😍", "🤩", "😘", "😗", "☺️", "😚", "😙", "🥲", "😋", "😛", "😜", "🤪", "😝", "🤑", "🤗", "🤭", "🫢", "🫣", "🤫", "🤔", "🫡", "🤐", "🤨", "😐", "😑", "😶", "🫥", "😶‍🌫️", "😏", "😒", "🙄", "😬", "😮‍💨", "🤥", "😌", "😔", "😪", "🤤", "😴", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "🥵", "🥶", "🥴", "😵", "😵‍💫", "🤯", "🤠", "🥳", "🥸", "😎", "🤓", "🧐", "😕", "🫤", "😟", "🙁", "☹️", "😮", "😯", "😲", "😳", "🥺", "🥹", "😦", "😧", "😨", "😰", "😥", "😢", "😭", "😱", "😖", "😣", "😞", "😓", "😩", "😫", "🥱", "😤", "😡", "😠", "🤬", "😈", "👿", "💀", "☠️", "💩", "🤡", "👹", "👺", "👻", "👽", "👾", "🤖", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "💋", "👋", "🤚", "🖐️", "✋", "🖖", "🫱", "🫲", "🫳", "🫴", "👌", "🤌", "🤏", "✌️", "🤞", "🫰", "🤟", "🤘", "🤙", "👈", "👉", "👆", "🖕", "👇", "☝️", "🫵", "👍", "👎", "✊", "👊", "🤛", "🤜", "👏", "🙌", "🫶", "👐", "🤲", "🤝", "🙏", "✍️", "💅", "🤳", "💪", "🦾", "🦿", "🦵", "🦶", "👂", "🦻", "👃", "🧠", "🫀", "🫁", "🦷", "🦴", "👀", "👁️", "👅", "👄", "🫦", "👶", "🧒", "👦", "👧", "🧑", "👱", "👨", "🧔", "👨‍🦰", "👨‍🦱", "👨‍🦳", "👨‍🦲", "👩", "👩‍🦰", "🧑‍🦰", "👩‍🦱", "🧑‍🦱", "👩‍🦳", "🧑‍🦳", "👩‍🦲", "🧑‍🦲", "👱‍♀️", "👱‍♂️", "🧓", "👴", "👵", "🙍", "🙍‍♂️", "🙍‍♀️", "🙎", "🙎‍♂️", "🙎‍♀️", "🙅", "🙅‍♂️", "🙅‍♀️", "🙆", "🙆‍♂️", "🙆‍♀️", "💁", "💁‍♂️", "💁‍♀️", "🙋", "🙋‍♂️", "🙋‍♀️", "🧏", "🧏‍♂️", "🧏‍♀️", "🙇", "🙇‍♂️", "🙇‍♀️", "🤦", "🤦‍♂️", "🤦‍♀️", "🤷", "🤷‍♂️", "🤷‍♀️", "🧑‍⚕️", "👨‍⚕️", "👩‍⚕️", "🧑‍🎓", "👨‍🎓", "👩‍🎓", "🧑‍🏫", "👨‍🏫", "👩‍🏫", "🧑‍⚖️", "👨‍⚖️", "👩‍⚖️", "🧑‍🌾", "👨‍🌾", "👩‍🌾", "🧑‍🍳", "👨‍🍳", "👩‍🍳", "🧑‍🔧", "👨‍🔧", "👩‍🔧", "🧑‍🏭", "👨‍🏭", "👩‍🏭", "🧑‍💼", "👨‍💼", "👩‍💼", "🧑‍🔬", "👨‍🔬", "👩‍🔬", "🧑‍💻", "👨‍💻", "👩‍💻", "🧑‍🎤", "👨‍🎤", "👩‍🎤", "🧑‍🎨", "👨‍🎨", "👩‍🎨", "🧑‍✈️", "👨‍✈️", "👩‍✈️", "🧑‍🚀", "👨‍🚀", "👩‍🚀", "🧑‍🚒", "👨‍🚒", "👩‍🚒", "👮", "👮‍♂️", "👮‍♀️", "🕵️", "🕵️‍♂️", "🕵️‍♀️", "💂", "💂‍♂️", "💂‍♀️", "🥷", "👷", "👷‍♂️", "👷‍♀️", "🫅", "🤴", "👸", "👳", "👳‍♂️", "👳‍♀️", "👲", "🧕", "🤵", "🤵‍♂️", "🤵‍♀️", "👰", "👰‍♂️", "👰‍♀️", "🤰", "🫃", "🫄", "🤱", "👩‍🍼", "👨‍🍼", "🧑‍🍼", "👼", "🎅", "🤶", "🧑‍🎄", "🦸", "🦸‍♂️", "🦸‍♀️", "🦹", "🦹‍♂️", "🦹‍♀️", "🧙", "🧙‍♂️", "🧙‍♀️", "🧚", "🧚‍♂️", "🧚‍♀️", "🧛", "🧛‍♂️", "🧛‍♀️", "🧜", "🧜‍♂️", "🧜‍♀️", "🧝", "🧝‍♂️", "🧝‍♀️", "🧞", "🧞‍♂️", "🧞‍♀️", "🧟", "🧟‍♂️", "🧟‍♀️", "🧌", "💆", "💆‍♂️", "💆‍♀️", "💇", "💇‍♂️", "💇‍♀️", "🚶", "🚶‍♂️", "🚶‍♀️", "🧍", "🧍‍♂️", "🧍‍♀️", "🧎", "🧎‍♂️", "🧎‍♀️", "🧑‍🦯", "👨‍🦯", "👩‍🦯", "🧑‍🦼", "👨‍🦼", "👩‍🦼", "🧑‍🦽", "👨‍🦽", "👩‍🦽", "🏃", "🏃‍♂️", "🏃‍♀️", "💃", "🕺", "🕴️", "👯", "👯‍♂️", "👯‍♀️", "🧖", "🧖‍♂️", "🧖‍♀️", "🧘", "🧑‍🤝‍🧑", "👭", "👫", "👬", "💏", "👩‍❤️‍💋‍👨", "👨‍❤️‍💋‍👨", "👩‍❤️‍💋‍👩", "💑", "👩‍❤️‍👨", "👨‍❤️‍👨", "👩‍❤️‍👩", "👪", "👨‍👩‍👦", "👨‍👩‍👧", "👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦", "👨‍👩‍👧‍👧", "👨‍👨‍👦", "👨‍👨‍👧", "👨‍👨‍👧‍👦", "👨‍👨‍👦‍👦", "👨‍👨‍👧‍👧", "👩‍👩‍👦", "👩‍👩‍👧", "👩‍👩‍👧‍👦", "👩‍👩‍👦‍👦", "👩‍👩‍👧‍👧", "👨‍👦", "👨‍👦‍👦", "👨‍👧", "👨‍👧‍👦", "👨‍👧‍👧", "👩‍👦", "👩‍👦‍👦", "👩‍👧", "👩‍👧‍👦", "👩‍👧‍👧", "🗣️", "👤", "👥", "🫂", "👣", "🧳", "🌂", "☂️", "🎃", "🧵", "🧶", "👓", "🕶️", "🥽", "🥼", "🦺", "👔", "👕", "👖", "🧣", "🧤", "🧥", "🧦", "👗", "👘", "🥻", "🩱", "🩲", "🩳", "👙", "👚", "👛", "👜", "👝", "🎒", "🩴", "👞", "👟", "🥾", "🥿", "👠", "👡", "🩰", "👢", "👑", "👒", "🎩", "🎓", "🧢", "🪖", "⛑️", "💄", "💍", "💼", "🩸"]
    
    static let peopleDictionary = ["Woman Shrugging": "🤷‍♀️", "Woman Singer": "👩‍🎤", "Boy": "👦", "Man Feeding Baby": "👨‍🍼", "Thumbs Up": "👍", "Person Raising Hand": "🙋", "Pensive Face": "😔", "Man Elf": "🧝‍♂️", "Person Running": "🏃", "Rightwards Hand": "🫱", "Kiss": "💏", "Backhand Index Pointing Right": "👉", "Heart Hands": "🫶", "Woman in Motorized Wheelchair": "👩‍🦼", "Deaf Woman": "🧏‍♀️", "Robot": "🤖", "Women with Bunny Ears": "👯‍♀️", "Man": "👨", "Person Frowning": "🙍", "Family: Man, Man, Boy, Boy": "👨‍👨‍👦‍👦", "Sunglasses": "🕶️", "Pleading Face": "🥺", "Couple with Heart: Woman, Woman": "👩‍❤️‍👩", "Tired Face": "😫", "Detective": "🕵️", "Person Tipping Hand": "💁", "Woman Health Worker": "👩‍⚕️", "Persevering Face": "😣", "Kiss Mark": "💋", "Hushed Face": "😯", "Backhand Index Pointing Down": "👇", "Skull and Crossbones": "☠️", "Nauseated Face": "🤢", "Man Mage": "🧙‍♂️", "Face with Hand Over Mouth": "🤭", "Face with Open Mouth": "😮", "Kiss: Woman, Woman": "👩‍❤️‍💋‍👩", "Person: White Hair": "🧑‍🦳", "Face Screaming in Fear": "😱", "Woman Scientist": "👩‍🔬", "Family: Man, Woman, Girl": "👨‍👩‍👧", "Man Dancing": "🕺", "Woman Walking": "🚶‍♀️", "Family: Woman, Woman, Boy, Boy": "👩‍👩‍👦‍👦", "Family: Man, Girl, Boy": "👨‍👧‍👦", "Scarf": "🧣", "Couple with Heart: Man, Man": "👨‍❤️‍👨", "Partying Face": "🥳", "Woman Pilot": "👩‍✈️", "Princess": "👸", "Woman Genie": "🧞‍♀️", "Mermaid": "🧜‍♀️", "Hand with Fingers Splayed": "🖐️", "Luggage": "🧳", "Family: Woman, Woman, Girl, Boy": "👩‍👩‍👧‍👦", "Downcast Face with Sweat": "😓", "Baby": "👶", "Woman Superhero": "🦸‍♀️", "Person Facepalming": "🤦", "Person Walking": "🚶", "Kissing Face with Smiling Eyes": "😙", "Love-You Gesture": "🤟", "Fairy": "🧚", "Smiling Face with Heart-Eyes": "😍", "Astonished Face": "😲", "Woman Facepalming": "🤦‍♀️", "Family": "👪", "Grinning Face with Sweat": "😅", "Supervillain": "🦹", "Face with Spiral Eyes": "😵‍💫", "Man Running": "🏃‍♂️", "Person: Blond Hair": "👱", "Man Mechanic": "👨‍🔧", "Mage": "🧙", "Person in Lotus Position": "🧘", "Bust in Silhouette": "👤", "Ghost": "👻", "Pilot": "🧑‍✈️", "Woman: Curly Hair": "👩‍🦱", "Face Exhaling": "😮‍💨", "Woman Fairy": "🧚‍♀️", "Face with Thermometer": "🤒", "Sleepy Face": "😪", "Goggles": "🥽", "Billed Cap": "🧢", "Grinning Squinting Face": "😆", "Slightly Frowning Face": "🙁", "Man: White Hair": "👨‍🦳", "Family: Man, Woman, Boy, Boy": "👨‍👩‍👦‍👦", "Jack-O-Lantern": "🎃", "Woman Raising Hand": "🙋‍♀️", "Cat with Wry Smile": "😼", "Glasses": "👓", "Kiss: Man, Man": "👨‍❤️‍💋‍👨", "Woman Mechanic": "👩‍🔧", "Ear with Hearing Aid": "🦻", "Backpack": "🎒", "Cold Face": "🥶", "Farmer": "🧑‍🌾", "Face with Head-Bandage": "🤕", "Handbag": "👜", "Vampire": "🧛", "Crying Cat": "😿", "Gloves": "🧤", "Relieved Face": "😌", "Man Fairy": "🧚‍♂️", "Man Facepalming": "🤦‍♂️", "Person Gesturing No": "🙅", "Family: Man, Girl": "👨‍👧", "Thread": "🧵", "Man: Curly Hair": "👨‍🦱", "One-Piece Swimsuit": "🩱", "People Hugging": "🫂", "Anguished Face": "😧", "Crossed Fingers": "🤞", "Weary Cat": "🙀", "Person with White Cane": "🧑‍🦯", "Grimacing Face": "😬", "Leftwards Hand": "🫲", "Star-Struck": "🤩", "Person: Red Hair": "🧑‍🦰", "Man Guard": "💂‍♂️", "Person: Beard": "🧔", "Man Superhero": "🦸‍♂️", "Worried Face": "😟", "Man Detective": "🕵️‍♂️", "Beaming Face with Smiling Eyes": "😁", "Man Scientist": "👨‍🔬", "Face with Peeking Eye": "🫣", "Kissing Cat": "😽", "Man Factory Worker": "👨‍🏭", "Face with Rolling Eyes": "🙄", "Woman Dancing": "💃", "Family: Woman, Woman, Girl": "👩‍👩‍👧", "Woman in Manual Wheelchair": "👩‍🦽", "Face with Tongue": "😛", "Woman Guard": "💂‍♀️", "Woman’s Sandal": "👡", "Woman Cook": "👩‍🍳", "Man Getting Massage": "💆‍♂️", "Scientist": "🧑‍🔬", "Guard": "💂", "Grinning Face": "😀", "Woman’s Clothes": "👚", "Crown": "👑", "Technologist": "🧑‍💻", "Yawning Face": "🥱", "Jeans": "👖", "Exploding Head": "🤯", "Family: Man, Man, Boy": "👨‍👨‍👦", "Genie": "🧞", "Person in Suit Levitating": "🕴️", "Person with Veil": "👰", "Woman Gesturing OK": "🙆‍♀️", "Woman Firefighter": "👩‍🚒", "Deaf Person": "🧏", "Woman Supervillain": "🦹‍♀️", "Hot Face": "🥵", "Police Officer": "👮", "Melting Face": "🫠", "Coat": "🧥", "Mechanic": "🧑‍🔧", "Leg": "🦵", "Woman: Red Hair": "👩‍🦰", "Frowning Face with Open Mouth": "😦", "Dotted Line Face": "🫥", "Flushed Face": "😳", "Index Pointing at the Viewer": "🫵", "Man Bowing": "🙇‍♂️", "Deaf Man": "🧏‍♂️", "Cook": "🧑‍🍳", "Mrs. Claus": "🤶", "Man Police Officer": "👮‍♂️", "Bikini": "👙", "Face with Steam From Nose": "😤", "Man Judge": "👨‍⚖️", "Men with Bunny Ears": "👯‍♂️", "Smiling Face with Hearts": "🥰", "Face Savoring Food": "😋", "Man in Manual Wheelchair": "👨‍🦽", "Zombie": "🧟", "Tooth": "🦷", "Pregnant Person": "🫄", "Call Me Hand": "🤙", "Alien Monster": "👾", "Man Wearing Turban": "👳‍♂️", "Woman’s Boot": "👢", "Loudly Crying Face": "😭", "Lab Coat": "🥼", "Face with Tears of Joy": "😂", "Running Shoe": "👟", "Socks": "🧦", "Family: Man, Man, Girl": "👨‍👨‍👧", "Man Technologist": "👨‍💻", "Smiling Face with Open Hands": "🤗", "Kiss: Woman, Man": "👩‍❤️‍💋‍👨", "Ear": "👂", "Woman with Veil": "👰‍♀️", "Saluting Face": "🫡", "Woman Frowning": "🙍‍♀️", "Man in Tuxedo": "🤵‍♂️", "Alien": "👽", "Man Pouting": "🙎‍♂️", "Writing Hand": "✍️", "Baby Angel": "👼", "Merman": "🧜‍♂️", "Angry Face with Horns": "👿", "Smiling Face with Smiling Eyes": "😊", "Face with Open Eyes and Hand Over Mouth": "🫢", "Middle Finger": "🖕", "Man Student": "👨‍🎓", "Woman with Headscarf": "🧕", "Superhero": "🦸", "Grinning Face with Smiling Eyes": "😄", "Sleeping Face": "😴", "Cowboy Hat Face": "🤠", "Flexed Biceps": "💪", "Woman Zombie": "🧟‍♀️", "Confused Face": "😕", "Raised Hand": "✋", "Person": "🧑", "Person Bowing": "🙇", "Woman Running": "🏃‍♀️", "Family: Man, Woman, Girl, Girl": "👨‍👩‍👧‍👧", "Winking Face with Tongue": "😜", "Man Walking": "🚶‍♂️", "Merperson": "🧜", "Grinning Cat": "😺", "Left-Facing Fist": "🤛", "Prince": "🤴", "Flat Shoe": "🥿", "Woman and Man Holding Hands": "👫", "Anatomical Heart": "🫀", "Man Shrugging": "🤷‍♂️", "Unamused Face": "😒", "Anxious Face with Sweat": "😰", "Pregnant Woman": "🤰", "Brain": "🧠", "Woman Kneeling": "🧎‍♀️", "Mouth": "👄", "Person Kneeling": "🧎", "People Holding Hands": "🧑‍🤝‍🧑", "Nose": "👃", "Woman Mage": "🧙‍♀️", "Family: Man, Boy": "👨‍👦", "Lying Face": "🤥", "Man Pilot": "👨‍✈️", "Man Teacher": "👨‍🏫", "Palm Up Hand": "🫴", "Woman Bowing": "🙇‍♀️", "Face Holding Back Tears": "🥹", "Palm Down Hand": "🫳", "Kissing Face with Closed Eyes": "😚", "Man Kneeling": "🧎‍♂️", "Man Health Worker": "👨‍⚕️", "Bone": "🦴", "Nail Polish": "💅", "Older Person": "🧓", "Man with Veil": "👰‍♂️", "Face Blowing a Kiss": "😘", "Santa Claus": "🎅", "Dress": "👗", "Face in Clouds": "😶‍🌫️", "Man: Red Hair": "👨‍🦰", "Person: Bald": "🧑‍🦲", "Clapping Hands": "👏", "Woman: Bald": "👩‍🦲", "Angry Face": "😠", "Family: Man, Woman, Girl, Boy": "👨‍👩‍👧‍👦", "Person Shrugging": "🤷", "Person Getting Haircut": "💇", "Face Without Mouth": "😶", "Sneezing Face": "🤧", "Man in Steamy Room": "🧖‍♂️", "Woman Artist": "👩‍🎨", "Grinning Cat with Smiling Eyes": "😸", "Drooling Face": "🤤", "Ring": "💍", "Person in Tuxedo": "🤵", "Man: Blond Hair": "👱‍♂️", "Face with Medical Mask": "😷", "Woman Vampire": "🧛‍♀️", "Person in Manual Wheelchair": "🧑‍🦽", "Man Standing": "🧍‍♂️", "T-Shirt": "👕", "Purse": "👛", "Woman Astronaut": "👩‍🚀", "Health Worker": "🧑‍⚕️", "Crying Face": "😢", "Waving Hand": "👋", "Briefs": "🩲", "Pile of Poo": "💩", "Rolling on the Floor Laughing": "🤣", "Man Construction Worker": "👷‍♂️", "Man Singer": "👨‍🎤", "Man Cook": "👨‍🍳", "Skull": "💀", "Smiling Face with Sunglasses": "😎", "Man Zombie": "🧟‍♂️", "Vulcan Salute": "🖖", "Person with Crown": "🫅", "Neutral Face": "😐", "Face Vomiting": "🤮", "Woman: White Hair": "👩‍🦳", "Cat with Tears of Joy": "😹", "Smiling Face with Horns": "😈", "Folded Hands": "🙏", "Woman Police Officer": "👮‍♀️", "Person with Skullcap": "👲", "Woman Construction Worker": "👷‍♀️", "Man Astronaut": "👨‍🚀", "Shushing Face": "🤫", "Slightly Smiling Face": "🙂", "Lungs": "🫁", "Enraged Face": "😡", "Raised Back of Hand": "🤚", "Man Supervillain": "🦹‍♂️", "Right-Facing Fist": "🤜", "Umbrella": "☂️", "Man Frowning": "🙍‍♂️", "Student": "🧑‍🎓", "Speaking Head": "🗣️", "Woman Teacher": "👩‍🏫", "Person Gesturing OK": "🙆", "Selfie": "🤳", "Briefcase": "💼", "Man Artist": "👨‍🎨", "Man in Motorized Wheelchair": "👨‍🦼", "Woman: Blond Hair": "👱‍♀️", "Man Gesturing OK": "🙆‍♂️", "Pinching Hand": "🤏", "Old Woman": "👵", "Family: Man, Man, Girl, Boy": "👨‍👨‍👧‍👦", "Sari": "🥻", "Woman in Steamy Room": "🧖‍♀️", "Person: Curly Hair": "🧑‍🦱", "Biting Lip": "🫦", "Eyes": "👀", "Woman": "👩", "Woman Wearing Turban": "👳‍♀️", "Woman Pouting": "🙎‍♀️", "Index Pointing Up": "☝️", "Yarn": "🧶", "Ninja": "🥷", "Man: Bald": "👨‍🦲", "Squinting Face with Tongue": "😝", "Grinning Face with Big Eyes": "😃", "Family: Man, Man, Girl, Girl": "👨‍👨‍👧‍👧", "Busts in Silhouette": "👥", "Women Holding Hands": "👭", "Man Gesturing No": "🙅‍♂️", "Family: Woman, Woman, Girl, Girl": "👩‍👩‍👧‍👧", "Kissing Face": "😗", "Construction Worker": "👷", "Weary Face": "😩", "Family: Woman, Girl": "👩‍👧", "Sad but Relieved Face": "😥", "Woman in Tuxedo": "🤵‍♀️", "Breast-Feeding": "🤱", "Woman Tipping Hand": "💁‍♀️", "Woman Feeding Baby": "👩‍🍼", "Person Standing": "🧍", "Nerd Face": "🤓", "Tongue": "👅", "Kimono": "👘", "Man Getting Haircut": "💇‍♂️", "Thinking Face": "🤔", "Woman Elf": "🧝‍♀️", "Person in Motorized Wheelchair": "🧑‍🦼", "Pregnant Man": "🫃", "Person in Steamy Room": "🧖", "Eye": "👁️", "Smirking Face": "😏", "Person Getting Massage": "💆", "Woman Gesturing No": "🙅‍♀️", "Child": "🧒", "Couple with Heart": "💑", "Clutch Bag": "👝", "Old Man": "👴", "Firefighter": "🧑‍🚒", "Smiling Cat with Heart-Eyes": "😻", "Judge": "🧑‍⚖️", "Disappointed Face": "😞", "Sign of the Horns": "🤘", "Woman Farmer": "👩‍🌾", "Smiling Face": "☺️", "Girl": "👧", "Backhand Index Pointing Up": "👆", "Woman Judge": "👩‍⚖️", "Woman Technologist": "👩‍💻", "Man Tipping Hand": "💁‍♂️", "Footprints": "👣", "Thong Sandal": "🩴", "Man Raising Hand": "🙋‍♂️", "Man Vampire": "🧛‍♂️", "Ogre": "👹", "Hiking Boot": "🥾", "Family: Man, Boy, Boy": "👨‍👦‍👦", "Family: Woman, Girl, Girl": "👩‍👧‍👧", "Mechanical Leg": "🦿", "Mechanical Arm": "🦾", "Foot": "🦶", "Safety Vest": "🦺", "Woman Standing": "🧍‍♀️", "Woman Detective": "🕵️‍♀️", "Mx Claus": "🧑‍🎄", "Necktie": "👔", "Open Hands": "👐", "Drop of Blood": "🩸", "OK Hand": "👌", "People with Bunny Ears": "👯", "Ballet Shoes": "🩰", "Shorts": "🩳", "Artist": "🧑‍🎨", "Lipstick": "💄", "Zipper-Mouth Face": "🤐", "Woman with White Cane": "👩‍🦯", "Money-Mouth Face": "🤑", "Top Hat": "🎩", "Oncoming Fist": "👊", "Pinched Fingers": "🤌", "Clown Face": "🤡", "Office Worker": "🧑‍💼", "Elf": "🧝", "Goblin": "👺", "Palms Up Together": "🤲", "Man Office Worker": "👨‍💼", "Woman’s Hat": "👒", "Confounded Face": "😖", "Graduation Cap": "🎓", "Family: Woman, Boy": "👩‍👦", "Woman Office Worker": "👩‍💼", "Person Feeding Baby": "🧑‍🍼", "Men Holding Hands": "👬", "Pouting Cat": "😾", "Military Helmet": "🪖", "Family: Man, Woman, Boy": "👨‍👩‍👦", "Family: Man, Girl, Girl": "👨‍👧‍👧", "Woman Student": "👩‍🎓", "Singer": "🧑‍🎤", "Man with White Cane": "👨‍🦯", "Man Farmer": "👨‍🌾", "Man Genie": "🧞‍♂️", "Backhand Index Pointing Left": "👈", "Face with Raised Eyebrow": "🤨", "Closed Umbrella": "🌂", "Factory Worker": "🧑‍🏭", "Teacher": "🧑‍🏫", "Expressionless Face": "😑", "Face with Monocle": "🧐", "Family: Woman, Boy, Boy": "👩‍👦‍👦", "Hand with Index Finger and Thumb Crossed": "🫰", "Raised Fist": "✊", "Man’s Shoe": "👞", "Woman Getting Haircut": "💇‍♀️", "Handshake": "🤝", "Woman Getting Massage": "💆‍♀️", "Couple with Heart: Woman, Man": "👩‍❤️‍👨", "Winking Face": "😉", "Smiling Face with Halo": "😇", "Frowning Face": "☹️", "Rescue Worker’s Helmet": "⛑️", "Woman Factory Worker": "👩‍🏭", "Woozy Face": "🥴", "Fearful Face": "😨", "Smiling Face with Tear": "🥲", "Face with Crossed-Out Eyes": "😵", "Face with Diagonal Mouth": "🫤", "Thumbs Down": "👎", "High-Heeled Shoe": "👠", "Person Wearing Turban": "👳", "Face with Symbols on Mouth": "🤬", "Troll": "🧌", "Person Pouting": "🙎", "Raising Hands": "🙌", "Astronaut": "🧑‍🚀", "Family: Woman, Woman, Boy": "👩‍👩‍👦", "Family: Woman, Girl, Boy": "👩‍👧‍👦", "Upside-Down Face": "🙃", "Disguised Face": "🥸", "Man Firefighter": "👨‍🚒", "Zany Face": "🤪", "Victory Hand": "✌️"]
    
    static let animalsNNature = ["🙈", "🙉", "🙊", "💥", "💫", "💦", "💨", "🐵", "🐒", "🦍", "🦧", "🐶", "🐕", "🦮", "🐕‍🦺", "🐩", "🐺", "🦊", "🦝", "🐱", "🐈", "🐈‍⬛", "🦁", "🐯", "🐅", "🐆", "🐴", "🐎", "🦄", "🦓", "🦌", "🦬", "🐮", "🐂", "🐃", "🐄", "🐷", "🐖", "🐗", "🐽", "🐏", "🐑", "🐐", "🐪", "🐫", "🦙", "🦒", "🐘", "🦣", "🦏", "🦛", "🐭", "🐁", "🐀", "🐹", "🐰", "🐇", "🐿️", "🦫", "🦔", "🦇", "🐻", "🐻‍❄️", "🐨", "🐼", "🦥", "🦦", "🦨", "🦘", "🦡", "🐾", "🦃", "🐔", "🐓", "🐣", "🐤", "🐥", "🐦", "🐧", "🕊️", "🦅", "🦆", "🦢", "🦉", "🦤", "🪶", "🦩", "🦚", "🦜", "🐸", "🐊", "🐢", "🦎", "🐍", "🐲", "🐉", "🦕", "🦖", "🐳", "🐋", "🐬", "🦭", "🐟", "🐠", "🐡", "🦈", "🐙", "🐚", "🪸", "🐌", "🦋", "🐛", "🐜", "🐝", "🪲", "🐞", "🦗", "🪳", "🕷️", "🕸️", "🦂", "🦟", "🪰", "🪱", "🦠", "💐", "🌸", "💮", "🪷", "🏵️", "🌹", "🥀", "🌺", "🌻", "🌼", "🌷", "🌱", "🪴", "🌲", "🌳", "🌴", "🌵", "🌾", "🌿", "☘️", "🍀", "🍁", "🍂", "🍃", "🪹", "🪺", "🍄", "🌰", "🦀", "🦞", "🦐", "🦑", "🌍", "🌎", "🌏", "🌐", "🪨", "🌑", "🌒", "🌓", "🌔", "🌕", "🌖", "🌗", "🌘", "🌙", "🌚", "🌛", "🌜", "☀️", "🌝", "🌞", "⭐", "🌟", "🌠", "☁️", "⛅", "⛈️", "🌤️", "🌥️", "🌦️", "🌧️", "🌨️", "🌩️", "🌪️", "🌫️", "🌬️", "🌈", "☂️", "☔", "⚡", "❄️", "☃️", "⛄", "☄️", "🔥", "💧", "🌊", "🎄", "✨", "🎋", "🎍", "🫧"]
    
    static let animalsNNatureDictionary = ["Four Leaf Clover": "🍀", "Chicken": "🐔", "Tornado": "🌪️", "Whale": "🐋", "Pig Nose": "🐽", "Shamrock": "☘️", "Sheaf of Rice": "🌾", "Lotus": "🪷", "Goat": "🐐", "New Moon": "🌑", "Mosquito": "🦟", "Feather": "🪶", "Beetle": "🪲", "Baby Chick": "🐤", "T-Rex": "🦖", "Rabbit": "🐇", "Waxing Crescent Moon": "🌒", "First Quarter Moon": "🌓", "Gorilla": "🦍", "Guide Dog": "🦮", "Koala": "🐨", "Pine Decoration": "🎍", "Penguin": "🐧", "Collision": "💥", "Wind Face": "🌬️", "Potted Plant": "🪴", "Bison": "🦬", "Cactus": "🌵", "Cow Face": "🐮", "Umbrella": "☂️", "Umbrella with Rain Drops": "☔", "Spider Web": "🕸️", "Horse Face": "🐴", "Black Cat": "🐈‍⬛", "Orangutan": "🦧", "Sun Behind Large Cloud": "🌥️", "Hamster": "🐹", "Fish": "🐟", "Sun": "☀️", "Frog": "🐸", "Cherry Blossom": "🌸", "Water Buffalo": "🐃", "Crab": "🦀", "Scorpion": "🦂", "Coral": "🪸", "Bird": "🐦", "White Flower": "💮", "Camel": "🐪", "Cloud": "☁️", "Hatching Chick": "🐣", "Mouse Face": "🐭", "Seal": "🦭", "Spiral Shell": "🐚", "Duck": "🦆", "Chipmunk": "🐿️", "Turkey": "🦃", "Pig Face": "🐷", "Evergreen Tree": "🌲", "Mouse": "🐁", "Boar": "🐗", "Water Wave": "🌊", "Ox": "🐂", "Crocodile": "🐊", "See-No-Evil Monkey": "🙈", "Swan": "🦢", "Waning Gibbous Moon": "🌖", "Polar Bear": "🐻‍❄️", "Tulip": "🌷", "Maple Leaf": "🍁", "Sun Behind Rain Cloud": "🌦️", "Mushroom": "🍄", "New Moon Face": "🌚", "Octopus": "🐙", "Lady Beetle": "🐞", "Bear": "🐻", "Honeybee": "🐝", "Christmas Tree": "🎄", "Dolphin": "🐬", "Otter": "🦦", "Globe Showing Europe-Africa": "🌍", "Dog": "🐕", "Dove": "🕊️", "Leaf Fluttering in Wind": "🍃", "Worm": "🪱", "Deer": "🦌", "Bouquet": "💐", "Horse": "🐎", "Cat": "🐈", "Sparkles": "✨", "Dragon Face": "🐲", "Rat": "🐀", "Spouting Whale": "🐳", "Full Moon Face": "🌝", "Lobster": "🦞", "Blowfish": "🐡", "Palm Tree": "🌴", "Fire": "🔥", "Hippopotamus": "🦛", "Paw Prints": "🐾", "Droplet": "💧", "High Voltage": "⚡", "Blossom": "🌼", "Deciduous Tree": "🌳", "Hear-No-Evil Monkey": "🙉", "Dizzy": "💫", "Snowman": "☃️", "Poodle": "🐩", "Tiger": "🐅", "Butterfly": "🦋", "Giraffe": "🦒", "Chestnut": "🌰", "Rabbit Face": "🐰", "Fog": "🌫️", "Tiger Face": "🐯", "Kangaroo": "🦘", "Nest with Eggs": "🪺", "Service Dog": "🐕‍🦺", "Cloud with Lightning and Rain": "⛈️", "Shooting Star": "🌠", "Ant": "🐜", "Elephant": "🐘", "Waning Crescent Moon": "🌘", "Last Quarter Moon Face": "🌜", "Rhinoceros": "🦏", "Globe with Meridians": "🌐", "Sunflower": "🌻", "Flamingo": "🦩", "Sun Behind Cloud": "⛅", "Fox": "🦊", "Snowman Without Snow": "⛄", "Owl": "🦉", "Monkey": "🐒", "Dragon": "🐉", "Dog Face": "🐶", "Speak-No-Evil Monkey": "🙊", "Zebra": "🦓", "Tanabata Tree": "🎋", "Hedgehog": "🦔", "Leopard": "🐆", "Eagle": "🦅", "Herb": "🌿", "Squid": "🦑", "Peacock": "🦚", "Llama": "🦙", "Tropical Fish": "🐠", "Sloth": "🦥", "Seedling": "🌱", "Monkey Face": "🐵", "Rainbow": "🌈", "Rooster": "🐓", "Crescent Moon": "🌙", "Fallen Leaf": "🍂", "Hibiscus": "🌺", "Bug": "🐛", "Unicorn": "🦄", "Turtle": "🐢", "Cricket": "🦗", "Rock": "🪨", "Cat Face": "🐱", "Dashing Away": "💨", "Wolf": "🐺", "Empty Nest": "🪹", "Snake": "🐍", "Front-Facing Baby Chick": "🐥", "Ram": "🐏", "Cockroach": "🪳", "Two-Hump Camel": "🐫", "Bat": "🦇", "Sweat Droplets": "💦", "Fly": "🪰", "Ewe": "🐑", "Lion": "🦁", "Cloud with Lightning": "🌩️", "Sun Behind Small Cloud": "🌤️", "Cloud with Rain": "🌧️", "Star": "⭐", "Wilted Flower": "🥀", "Cow": "🐄", "Glowing Star": "🌟", "Cloud with Snow": "🌨️", "Globe Showing Americas": "🌎", "Skunk": "🦨", "Shark": "🦈", "Shrimp": "🦐", "Badger": "🦡", "Full Moon": "🌕", "Microbe": "🦠", "Mammoth": "🦣", "Snowflake": "❄️", "Sauropod": "🦕", "Bubbles": "🫧", "Snail": "🐌", "Globe Showing Asia-Australia": "🌏", "Panda": "🐼", "Last Quarter Moon": "🌗", "Spider": "🕷️", "Raccoon": "🦝", "Sun with Face": "🌞", "Waxing Gibbous Moon": "🌔", "Pig": "🐖", "First Quarter Moon Face": "🌛", "Beaver": "🦫", "Parrot": "🦜", "Comet": "☄️", "Rosette": "🏵️", "Lizard": "🦎", "Dodo": "🦤", "Rose": "🌹"]
    
    static let foodNDrink = ["🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍑", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄", "🥜", "🫘", "🌰", "🍞", "🥐", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗", "🥩", "🥓", "🍔", "🍟", "🍕", "🌭", "🥪", "🌮", "🌯", "🫔", "🥙", "🧆", "🥚", "🍳", "🥘", "🍲", "🫕", "🥣", "🥗", "🍿", "🧈", "🧂", "🥫", "🍱", "🍘", "🍙", "🍚", "🍛", "🍜", "🍝", "🍠", "🍢", "🍣", "🍤", "🍥", "🥮", "🍡", "🥟", "🥠", "🥡", "🦪", "🍦", "🍧", "🍨", "🍩", "🍪", "🎂", "🍰", "🧁", "🥧", "🍫", "🍬", "🍭", "🍮", "🍯", "🍼", "🥛", "☕", "🫖", "🍵", "🍶", "🍾", "🍷", "🍸", "🍹", "🍺", "🍻", "🥂", "🥃", "🫗", "🥤", "🧋", "🧃", "🧉", "🧊", "🥢", "🍽️", "🍴", "🥄", "🫙"]
    
    static let foodNDrinkDictionary = ["Teacup Without Handle": "🍵", "Bread": "🍞", "Beans": "🫘", "Green Salad": "🥗", "Hot Dog": "🌭", "Curry Rice": "🍛", "Chopsticks": "🥢", "Ear of Corn": "🌽", "Garlic": "🧄", "Olive": "🫒", "Cucumber": "🥒", "Tamale": "🫔", "Fried Shrimp": "🍤", "Hot Beverage": "☕", "Clinking Beer Mugs": "🍻", "Custard": "🍮", "Cooked Rice": "🍚", "Sandwich": "🥪", "Kiwi Fruit": "🥝", "Doughnut": "🍩", "Baguette Bread": "🥖", "Leafy Green": "🥬", "Carrot": "🥕", "French Fries": "🍟", "Bento Box": "🍱", "Cherries": "🍒", "Lollipop": "🍭", "Pot of Food": "🍲", "Peach": "🍑", "Chestnut": "🌰", "Pie": "🥧", "Bubble Tea": "🧋", "Flatbread": "🫓", "Onion": "🧅", "Lemon": "🍋", "Bagel": "🥯", "Taco": "🌮", "Banana": "🍌", "Pineapple": "🍍", "Salt": "🧂", "Candy": "🍬", "Pretzel": "🥨", "Cookie": "🍪", "Baby Bottle": "🍼", "Falafel": "🧆", "Cheese Wedge": "🧀", "Butter": "🧈", "Potato": "🥔", "Dango": "🍡", "Honey Pot": "🍯", "Mango": "🥭", "Watermelon": "🍉", "Mushroom": "🍄", "Croissant": "🥐", "Ice Cream": "🍨", "Glass of Milk": "🥛", "Shallow Pan of Food": "🥘", "Sake": "🍶", "Cocktail Glass": "🍸", "Tomato": "🍅", "Fondue": "🫕", "Blueberries": "🫐", "Chocolate Bar": "🍫", "Grapes": "🍇", "Shaved Ice": "🍧", "Wine Glass": "🍷", "Ice": "🧊", "Waffle": "🧇", "Pear": "🍐", "Oyster": "🦪", "Hamburger": "🍔", "Bell Pepper": "🫑", "Oden": "🍢", "Cut of Meat": "🥩", "Green Apple": "🍏", "Roasted Sweet Potato": "🍠", "Rice Cracker": "🍘", "Broccoli": "🥦", "Teapot": "🫖", "Peanuts": "🥜", "Tropical Drink": "🍹", "Fork and Knife with Plate": "🍽️", "Rice Ball": "🍙", "Soft Ice Cream": "🍦", "Burrito": "🌯", "Mate": "🧉", "Jar": "🫙", "Clinking Glasses": "🥂", "Melon": "🍈", "Pancakes": "🥞", "Fortune Cookie": "🥠", "Bowl with Spoon": "🥣", "Cooking": "🍳", "Hot Pepper": "🌶️", "Cupcake": "🧁", "Tangerine": "🍊", "Moon Cake": "🥮", "Popcorn": "🍿", "Canned Food": "🥫", "Bottle with Popping Cork": "🍾", "Beverage Box": "🧃", "Beer Mug": "🍺", "Steaming Bowl": "🍜", "Coconut": "🥥", "Takeout Box": "🥡", "Tumbler Glass": "🥃", "Cup with Straw": "🥤", "Dumpling": "🥟", "Spaghetti": "🍝", "Sushi": "🍣", "Fork and Knife": "🍴", "Poultry Leg": "🍗", "Spoon": "🥄", "Fish Cake with Swirl": "🍥", "Pouring Liquid": "🫗", "Avocado": "🥑", "Shortcake": "🍰", "Stuffed Flatbread": "🥙", "Pizza": "🍕", "Egg": "🥚", "Eggplant": "🍆", "Bacon": "🥓", "Strawberry": "🍓", "Birthday Cake": "🎂", "Meat on Bone": "🍖", "Red Apple": "🍎"]

    
    static let activity = ["🕴️", "🧗", "🧗‍♂️", "🧗‍♀️", "🤺", "🏇", "⛷️", "🏂", "🏌️", "🏌️‍♂️", "🏌️‍♀️", "🏄", "🏄‍♂️", "🏄‍♀️", "🚣", "🚣‍♂️", "🚣‍♀️", "🏊", "🏊‍♂️", "🏊‍♀️", "⛹️", "⛹️‍♂️", "⛹️‍♀️", "🏋️", "🏋️‍♂️", "🏋️‍♀️", "🚴", "🚴‍♂️", "🚴‍♀️", "🚵", "🚵‍♂️", "🚵‍♀️", "🤸", "🤸‍♂️", "🤸‍♀️", "🤼", "🤼‍♂️", "🤼‍♀️", "🤽", "🤽‍♂️", "🤽‍♀️", "🤾", "🤾‍♂️", "🤾‍♀️", "🤹", "🤹‍♂️", "🤹‍♀️", "🧘", "🧘‍♂️", "🧘‍♀️", "🎪", "🛹", "🛼", "🛶", "🎗️", "🎟️", "🎫", "🎖️", "🏆", "🏅", "🥇", "🥈", "🥉", "⚽", "⚾", "🥎", "🏀", "🏐", "🏈", "🏉", "🎾", "🥏", "🎳", "🏏", "🏑", "🏒", "🥍", "🏓", "🏸", "🥊", "🥋", "🥅", "⛳", "⛸️", "🎣", "🎽", "🎿", "🛷", "🥌", "🎯", "🎱", "🎮", "🎰", "🎲", "🧩", "🪩", "♟️", "🎭", "🎨", "🧵", "🧶", "🎼", "🎤", "🎧", "🎷", "🪗", "🎸", "🎹", "🎺", "🎻", "🥁", "🪘", "🎬", "🏹"]
    
    static let activityDictionary = ["Person Lifting Weights": "🏋️", "Person in Suit Levitating": "🕴️", "Man Golfing": "🏌️‍♂️", "Person Surfing": "🏄", "Woman Playing Handball": "🤾‍♀️", "Man Cartwheeling": "🤸‍♂️", "Ice Hockey": "🏒", "Bow and Arrow": "🏹", "Musical Score": "🎼", "3rd Place Medal": "🥉", "Badminton": "🏸", "Mirror Ball": "🪩", "Running Shirt": "🎽", "Slot Machine": "🎰", "Skier": "⛷️", "1st Place Medal": "🥇", "Woman Mountain Biking": "🚵‍♀️", "Woman Climbing": "🧗‍♀️", "Soccer Ball": "⚽", "Canoe": "🛶", "Man Biking": "🚴‍♂️", "Trophy": "🏆", "Person Playing Handball": "🤾", "Snowboarder": "🏂", "Video Game": "🎮", "Man Playing Handball": "🤾‍♂️", "Thread": "🧵", "Headphone": "🎧", "Pool 8 Ball": "🎱", "Man Playing Water Polo": "🤽‍♂️", "Guitar": "🎸", "Man Bouncing Ball": "⛹️‍♂️", "Bowling": "🎳", "Skis": "🎿", "Yarn": "🧶", "American Football": "🏈", "Person Bouncing Ball": "⛹️", "Flying Disc": "🥏", "Martial Arts Uniform": "🥋", "Man Lifting Weights": "🏋️‍♂️", "Men Wrestling": "🤼‍♂️", "Woman Rowing Boat": "🚣‍♀️", "Microphone": "🎤", "Fishing Pole": "🎣", "Military Medal": "🎖️", "Musical Keyboard": "🎹", "Person Cartwheeling": "🤸", "Sled": "🛷", "Women Wrestling": "🤼‍♀️", "Violin": "🎻", "Accordion": "🪗", "Man Juggling": "🤹‍♂️", "Woman Juggling": "🤹‍♀️", "Roller Skate": "🛼", "Man Swimming": "🏊‍♂️", "Man Mountain Biking": "🚵‍♂️", "Ticket": "🎫", "Long Drum": "🪘", "Drum": "🥁", "Person Playing Water Polo": "🤽", "Woman Surfing": "🏄‍♀️", "Field Hockey": "🏑", "Tennis": "🎾", "Ice Skate": "⛸️", "Chess Pawn": "♟️", "Woman Bouncing Ball": "⛹️‍♀️", "Horse Racing": "🏇", "Woman Golfing": "🏌️‍♀️", "Artist Palette": "🎨", "Bullseye": "🎯", "Circus Tent": "🎪", "Puzzle Piece": "🧩", "Woman Lifting Weights": "🏋️‍♀️", "Trumpet": "🎺", "Goal Net": "🥅", "Boxing Glove": "🥊", "Basketball": "🏀", "Performing Arts": "🎭", "Baseball": "⚾", "Person Swimming": "🏊", "Cricket Game": "🏏", "Reminder Ribbon": "🎗️", "Skateboard": "🛹", "Volleyball": "🏐", "Woman Cartwheeling": "🤸‍♀️", "Person Juggling": "🤹", "Softball": "🥎", "Admission Tickets": "🎟️", "Woman Biking": "🚴‍♀️", "Man Climbing": "🧗‍♂️", "Person Biking": "🚴", "Clapper Board": "🎬", "People Wrestling": "🤼", "Saxophone": "🎷", "Woman Swimming": "🏊‍♀️", "Curling Stone": "🥌", "Person Rowing Boat": "🚣", "Woman in Lotus Position": "🧘‍♀️", "Person Climbing": "🧗", "Man Surfing": "🏄‍♂️", "2nd Place Medal": "🥈", "Person Golfing": "🏌️", "Game Die": "🎲", "Woman Playing Water Polo": "🤽‍♀️", "Person in Lotus Position": "🧘", "Rugby Football": "🏉", "Flag in Hole": "⛳", "Ping Pong": "🏓", "Person Mountain Biking": "🚵", "Man Rowing Boat": "🚣‍♂️", "Man in Lotus Position": "🧘‍♂️", "Sports Medal": "🏅", "Person Fencing": "🤺", "Lacrosse": "🥍"]
    
    static let travelNPlaces = ["🚣", "🗾", "🏔️", "⛰️", "🌋", "🗻", "🏕️", "🏖️", "🏜️", "🏝️", "🏞️", "🏟️", "🏛️", "🏗️", "🛖", "🏘️", "🏚️", "🏠", "🏡", "🏢", "🏣", "🏤", "🏥", "🏦", "🏨", "🏩", "🏪", "🏫", "🏬", "🏭", "🏯", "🏰", "💒", "🗼", "🗽", "⛪", "🕌", "🛕", "🕍", "⛩️", "🕋", "⛲", "⛺", "🌁", "🌃", "🏙️", "🌄", "🌅", "🌆", "🌇", "🌉", "🎠", "🛝", "🎡", "🎢", "🚂", "🚃", "🚄", "🚅", "🚆", "🚇", "🚈", "🚉", "🚊", "🚝", "🚞", "🚋", "🚌", "🚍", "🚎", "🚐", "🚑", "🚒", "🚓", "🚔", "🚕", "🚖", "🚗", "🚘", "🚙", "🛻", "🚚", "🚛", "🚜", "🏎️", "🏍️", "🛵", "🛺", "🚲", "🛴", "🚏", "🛣️", "🛤️", "⛽", "🛞", "🚨", "🚥", "🚦", "🚧", "⚓", "🛟", "⛵", "🚤", "🛳️", "⛴️", "🛥️", "🚢", "✈️", "🛩️", "🛫", "🛬", "🪂", "💺", "🚁", "🚟", "🚠", "🚡", "🛰️", "🚀", "🛸", "🪐", "🌠", "🌌", "⛱️", "🎆", "🎇", "🎑", "💴", "💵", "💶", "💷", "🗿", "🛂", "🛃", "🛄", "🛅"]
    
    static let travelNPlacesDictionary = ["Police Car Light": "🚨", "House with Garden": "🏡", "Ringed Planet": "🪐", "Love Hotel": "🏩", "Motor Scooter": "🛵", "Tram": "🚊", "Motor Boat": "🛥️", "Moon Viewing Ceremony": "🎑", "Hindu Temple": "🛕", "Ring Buoy": "🛟", "Bus Stop": "🚏", "House": "🏠", "Aerial Tramway": "🚡", "Map of Japan": "🗾", "Japanese Post Office": "🏣", "Baggage Claim": "🛄", "Motorway": "🛣️", "Japanese Castle": "🏯", "Bridge at Night": "🌉", "Mountain Cableway": "🚠", "Mosque": "🕌", "Yen Banknote": "💴", "Railway Track": "🛤️", "Ship": "🚢", "Umbrella on Ground": "⛱️", "Locomotive": "🚂", "Synagogue": "🕍", "Night with Stars": "🌃", "Passenger Ship": "🛳️", "Metro": "🚇", "Ferris Wheel": "🎡", "Shooting Star": "🌠", "Carousel Horse": "🎠", "Bus": "🚌", "Trolleybus": "🚎", "Racing Car": "🏎️", "Anchor": "⚓", "Volcano": "🌋", "Station": "🚉", "Dollar Banknote": "💵", "Convenience Store": "🏪", "Oncoming Bus": "🚍", "Small Airplane": "🛩️", "Beach with Umbrella": "🏖️", "Suspension Railway": "🚟", "Sunrise": "🌅", "Snow-Capped Mountain": "🏔️", "School": "🏫", "Hut": "🛖", "Oncoming Police Car": "🚔", "Kaaba": "🕋", "Airplane Departure": "🛫", "Bullet Train": "🚅", "Speedboat": "🚤", "National Park": "🏞️", "Parachute": "🪂", "Houses": "🏘️", "Train": "🚆", "Wheel": "🛞", "Airplane": "✈️", "Mountain": "⛰️", "Fuel Pump": "⛽", "Automobile": "🚗", "Taxi": "🚕", "Horizontal Traffic Light": "🚥", "Sparkler": "🎇", "Customs": "🛃", "Oncoming Automobile": "🚘", "Motorcycle": "🏍️", "Seat": "💺", "Railway Car": "🚃", "Hospital": "🏥", "Tram Car": "🚋", "Bicycle": "🚲", "Moai": "🗿", "Passport Control": "🛂", "High-Speed Train": "🚄", "Delivery Truck": "🚚", "Person Rowing Boat": "🚣", "Helicopter": "🚁", "Flying Saucer": "🛸", "Light Rail": "🚈", "Sunrise Over Mountains": "🌄", "Pound Banknote": "💷", "Post Office": "🏤", "Fountain": "⛲", "Vertical Traffic Light": "🚦", "Ferry": "⛴️", "Construction": "🚧", "Sunset": "🌇", "Shinto Shrine": "⛩️", "Factory": "🏭", "Sailboat": "⛵", "Euro Banknote": "💶", "Desert Island": "🏝️", "Fireworks": "🎆", "Playground Slide": "🛝", "Department Store": "🏬", "Camping": "🏕️", "Fire Engine": "🚒", "Statue of Liberty": "🗽", "Bank": "🏦", "Pickup Truck": "🛻", "Airplane Arrival": "🛬", "Monorail": "🚝", "Sport Utility Vehicle": "🚙", "Foggy": "🌁", "Mount Fuji": "🗻", "Church": "⛪", "Ambulance": "🚑", "Auto Rickshaw": "🛺", "Stadium": "🏟️", "Cityscape": "🏙️", "Desert": "🏜️", "Wedding": "💒", "Mountain Railway": "🚞", "Oncoming Taxi": "🚖", "Derelict House": "🏚️", "Police Car": "🚓", "Cityscape at Dusk": "🌆", "Tokyo Tower": "🗼", "Articulated Lorry": "🚛", "Satellite": "🛰️", "Left Luggage": "🛅", "Rocket": "🚀", "Office Building": "🏢", "Building Construction": "🏗️", "Tent": "⛺", "Milky Way": "🌌", "Castle": "🏰", "Hotel": "🏨", "Tractor": "🚜", "Classical Building": "🏛️", "Minibus": "🚐", "Kick Scooter": "🛴", "Roller Coaster": "🎢"]
    
    static let objects = ["💌", "🕳️", "💣", "🛀", "🛌", "🔪", "🏺", "🗺️", "🧭", "🧱", "💈", "🦽", "🦼", "🛢️", "🛎️", "🧳", "⌛", "⏳", "⌚", "⏰", "⏱️", "⏲️", "🕰️", "🌡️", "⛱️", "🧨", "🎈", "🎉", "🎊", "🎎", "🎏", "🎐", "🧧", "🎀", "🎁", "🤿", "🪀", "🪁", "🔮", "🪄", "🧿", "🪬", "🕹️", "🧸", "🪅", "🪆", "🖼️", "🧵", "🪡", "🧶", "🪢", "🛍️", "📿", "💎", "📯", "🎙️", "🎚️", "🎛️", "📻", "🪕", "📱", "📲", "☎️", "📞", "📟", "📠", "🔋", "🔌", "💻", "🖥️", "🖨️", "⌨️", "🖱️", "🖲️", "💽", "💾", "💿", "📀", "🧮", "🎥", "🎞️", "📽️", "📺", "📷", "📸", "📹", "📼", "🔍", "🔎", "🕯️", "💡", "🔦", "🏮", "🪔", "📔", "📕", "📖", "📗", "📘", "📙", "📚", "📓", "📒", "📃", "📜", "📄", "📰", "🗞️", "📑", "🔖", "🏷️", "💰", "🪙", "💴", "💵", "💶", "💷", "💸", "💳", "🧾", "✉️", "📧", "📨", "📩", "📤", "📥", "📦", "📫", "📪", "📬", "📭", "📮", "🗳️", "✏️", "✒️", "🖋️", "🖊️", "🖌️", "🖍️", "📝", "📁", "📂", "🗂️", "📅", "📆", "🗒️", "🗓️", "📇", "📈", "📉", "📊", "📋", "📌", "📍", "📎", "🖇️", "📏", "📐", "✂️", "🗃️", "🗄️", "🗑️", "🔒", "🔓", "🔏", "🔐", "🔑", "🗝️", "🔨", "🪓", "⛏️", "⚒️", "🛠️", "🗡️", "⚔️", "🔫", "🪃", "🛡️", "🪚", "🔧", "🪛", "🔩", "⚙️", "🗜️", "⚖️", "🦯", "🔗", "⛓️", "🪝", "🧰", "🧲", "🪜", "⚗️", "🧪", "🧫", "🧬", "🔬", "🔭", "📡", "💉", "🩸", "💊", "🩹", "🩼", "🩺", "🚪", "🪞", "🪟", "🛏️", "🛋️", "🪑", "🚽", "🪠", "🚿", "🛁", "🪤", "🪒", "🧴", "🧷", "🧹", "🧺", "🧻", "🪣", "🧼", "🪥", "🧽", "🧯", "🛒", "🚬", "⚰️", "🪦", "⚱️", "🗿", "🪧", "🪪", "🚰"]
    
    static let objectsDictionary = ["Magnifying Glass Tilted Right": "🔎", "Axe": "🪓", "Mirror": "🪞", "Locked": "🔒", "Card Index": "📇", "Razor": "🪒", "Manual Wheelchair": "🦽", "Locked with Key": "🔐", "Oil Drum": "🛢️", "Kite": "🪁", "Envelope": "✉️", "Money with Wings": "💸", "Headstone": "🪦", "Water Pistol": "🔫", "Fire Extinguisher": "🧯", "Computer Disk": "💽", "Television": "📺", "Black Nib": "✒️", "Bomb": "💣", "Ballot Box with Ballot": "🗳️", "Books": "📚", "Cigarette": "🚬", "Light Bulb": "💡", "Optical Disk": "💿", "Bar Chart": "📊", "Camera": "📷", "Mantelpiece Clock": "🕰️", "Kitchen Knife": "🔪", "Closed Book": "📕", "Crossed Swords": "⚔️", "Amphora": "🏺", "Diving Mask": "🤿", "Confetti Ball": "🎊", "Potable Water": "🚰", "Package": "📦", "Page with Curl": "📃", "Closed Mailbox with Raised Flag": "📫", "Paperclip": "📎", "DVD": "📀", "Movie Camera": "🎥", "Crayon": "🖍️", "Incoming Envelope": "📨", "Bucket": "🪣", "Piñata": "🪅", "Framed Picture": "🖼️", "Basket": "🧺", "Outbox Tray": "📤", "Compass": "🧭", "Yo-Yo": "🪀", "Nesting Dolls": "🪆", "Postal Horn": "📯", "Bathtub": "🛁", "Satellite Antenna": "📡", "Electric Plug": "🔌", "File Folder": "📁", "Notebook with Decorative Cover": "📔", "Nazar Amulet": "🧿", "Videocassette": "📼", "Bookmark": "🔖", "Red Paper Lantern": "🏮", "Broom": "🧹", "Bookmark Tabs": "📑", "Control Knobs": "🎛️", "Orange Book": "📙", "Stopwatch": "⏱️", "Locked with Pen": "🔏", "Studio Microphone": "🎙️", "Thermometer": "🌡️", "Door": "🚪", "Inbox Tray": "📥", "Party Popper": "🎉", "Prayer Beads": "📿", "Link": "🔗", "Round Pushpin": "📍", "Hammer": "🔨", "Shower": "🚿", "Funeral Urn": "⚱️", "Umbrella on Ground": "⛱️", "Ladder": "🪜", "Fountain Pen": "🖋️", "Page Facing Up": "📄", "Banjo": "🪕", "Barber Pole": "💈", "Plunger": "🪠", "Envelope with Arrow": "📩", "Tear-Off Calendar": "📆", "Thread": "🧵", "Open Mailbox with Raised Flag": "📬", "Level Slider": "🎚️", "Euro Banknote": "💶", "Battery": "🔋", "Floppy Disk": "💾", "Clamp": "🗜️", "Blue Book": "📘", "Magnifying Glass Tilted Left": "🔍", "Teddy Bear": "🧸", "Wind Chime": "🎐", "Scissors": "✂️", "Wastebasket": "🗑️", "Clipboard": "📋", "Magic Wand": "🪄", "Desktop Computer": "🖥️", "Pen": "🖊️", "Wrapped Gift": "🎁", "Placard": "🪧", "Receipt": "🧾", "Camera with Flash": "📸", "Dollar Banknote": "💵", "Keyboard": "⌨️", "Pick": "⛏️", "Linked Paperclips": "🖇️", "Mobile Phone with Arrow": "📲", "Person Taking Bath": "🛀", "Mouse Trap": "🪤", "Petri Dish": "🧫", "Sponge": "🧽", "Soap": "🧼", "Newspaper": "📰", "Timer Clock": "⏲️", "Screwdriver": "🪛", "Adhesive Bandage": "🩹", "Crutch": "🩼", "Firecracker": "🧨", "Hook": "🪝", "Unlocked": "🔓", "Key": "🔑", "Memo": "📝", "Joystick": "🕹️", "Hole": "🕳️", "Nut and Bolt": "🔩", "Crystal Ball": "🔮", "Dagger": "🗡️", "Hourglass Not Done": "⏳", "Card File Box": "🗃️", "Coffin": "⚰️", "Safety Pin": "🧷", "Alembic": "⚗️", "Telephone": "☎️", "Balance Scale": "⚖️", "Straight Ruler": "📏", "Toothbrush": "🪥", "Spiral Notepad": "🗒️", "Paintbrush": "🖌️", "Coin": "🪙", "Japanese Dolls": "🎎", "Old Key": "🗝️", "Toolbox": "🧰", "Knot": "🪢", "Hamsa": "🪬", "Sewing Needle": "🪡", "Lotion Bottle": "🧴", "Wrench": "🔧", "Shopping Cart": "🛒", "Pound Banknote": "💷", "Yarn": "🧶", "Scroll": "📜", "Fax Machine": "📠", "Pill": "💊", "Candle": "🕯️", "Toilet": "🚽", "File Cabinet": "🗄️", "Film Projector": "📽️", "E-Mail": "📧", "Computer Mouse": "🖱️", "Hammer and Wrench": "🛠️", "Bellhop Bell": "🛎️", "Carpentry Saw": "🪚", "Card Index Dividers": "🗂️", "Brick": "🧱", "Boomerang": "🪃", "Telephone Receiver": "📞", "Closed Mailbox with Lowered Flag": "📪", "Chair": "🪑", "Motorized Wheelchair": "🦼", "Window": "🪟", "Gear": "⚙️", "World Map": "🗺️", "Shopping Bags": "🛍️", "Radio": "📻", "Spiral Calendar": "🗓️", "Shield": "🛡️", "Money Bag": "💰", "Stethoscope": "🩺", "Film Frames": "🎞️", "Label": "🏷️", "White Cane": "🦯", "Abacus": "🧮", "Hourglass Done": "⌛", "Test Tube": "🧪", "Person in Bed": "🛌", "Mobile Phone": "📱", "Luggage": "🧳", "Carp Streamer": "🎏", "Red Envelope": "🧧", "Chart Decreasing": "📉", "Pushpin": "📌", "Laptop": "💻", "Video Camera": "📹", "DNA": "🧬", "Open Book": "📖", "Green Book": "📗", "Rolled-Up Newspaper": "🗞️", "Notebook": "📓", "Printer": "🖨️", "Couch and Lamp": "🛋️", "Triangular Ruler": "📐", "Love Letter": "💌", "Open File Folder": "📂", "Ledger": "📒", "Watch": "⌚", "Ribbon": "🎀", "Calendar": "📅", "Telescope": "🔭", "Magnet": "🧲", "Hammer and Pick": "⚒️", "Microscope": "🔬", "Drop of Blood": "🩸", "Syringe": "💉", "Moai": "🗿", "Pager": "📟", "Trackball": "🖲️", "Alarm Clock": "⏰", "Chart Increasing": "📈", "Flashlight": "🔦", "Credit Card": "💳", "Identification Card": "🪪", "Diya Lamp": "🪔", "Roll of Paper": "🧻", "Pencil": "✏️", "Yen Banknote": "💴", "Chains": "⛓️", "Gem Stone": "💎", "Postbox": "📮", "Open Mailbox with Lowered Flag": "📭", "Balloon": "🎈", "Bed": "🛏️"]
    
    static let symbols = ["💘", "💝", "💖", "💗", "💓", "💞", "💕", "💟", "❣️", "💔", "❤️‍🔥", "❤️‍🩹", "❤️", "🧡", "💛", "💚", "💙", "💜", "🤎", "🖤", "🤍", "💯", "💢", "💬", "👁️‍🗨️", "🗨️", "🗯️", "💭", "💤", "💮", "♨️", "💈", "🛑", "🕛", "🕧", "🕐", "🕜", "🕑", "🕝", "🕒", "🕞", "🕓", "🕟", "🕔", "🕠", "🕕", "🕡", "🕖", "🕢", "🕗", "🕣", "🕘", "🕤", "🕙", "🕥", "🕚", "🕦", "🌀", "♠️", "♥️", "♦️", "♣️", "🃏", "🀄", "🎴", "🔇", "🔈", "🔉", "🔊", "📢", "📣", "📯", "🔔", "🔕", "🎵", "🎶", "💹", "🛗", "🏧", "🚮", "🚰", "♿", "🚹", "🚺", "🚻", "🚼", "🚾", "⚠️", "🚸", "⛔", "🚫", "🚳", "🚭", "🚯", "🚱", "🚷", "📵", "🔞", "☢️", "☣️", "⬆️", "↗️", "➡️", "↘️", "⬇️", "↙️", "⬅️", "↖️", "↕️", "↔️", "↩️", "↪️", "⤴️", "⤵️", "🔃", "🔄", "🔙", "🔚", "🔛", "🔜", "🔝", "🛐", "⚛️", "🕉️", "✡️", "☸️", "☯️", "✝️", "☦️", "☪️", "☮️", "🕎", "🔯", "♈", "♉", "♊", "♋", "♌", "♍", "♎", "♏", "♐", "♑", "♒", "♓", "⛎", "🔀", "🔁", "🔂", "▶️", "⏩", "⏭️", "⏯️", "◀️", "⏪", "⏮️", "🔼", "⏫", "🔽", "⏬", "⏸️", "⏹️", "⏺️", "⏏️", "🎦", "🔅", "🔆", "📶", "📳", "📴", "♀️", "♂️", "✖️", "➕", "➖", "➗", "🟰", "♾️", "‼️", "⁉️", "❓", "❔", "❕", "❗", "〰️", "💱", "💲", "⚕️", "♻️", "⚜️", "🔱", "📛", "🔰", "⭕", "✅", "☑️", "✔️", "❌", "❎", "➰", "➿", "〽️", "✳️", "✴️", "❇️", "©️", "®️", "™️", "#️⃣", "*️⃣", "0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣", "🔟", "🔠", "🔡", "🔢", "🔣", "🔤", "🅰️", "🆎", "🅱️", "🆑", "🆒", "🆓", "ℹ️", "🆔", "Ⓜ️", "🆕", "🆖", "🅾️", "🆗", "🅿️", "🆘", "🆙", "🆚", "🈁", "🈂️", "🈷️", "🈶", "🈯", "🉐", "🈹", "🈚", "🈲", "🉑", "🈸", "🈴", "🈳", "㊗️", "㊙️", "🈺", "🈵", "🔴", "🟠", "🟡", "🟢", "🔵", "🟣", "🟤", "⚫", "⚪", "🟥", "🟧", "🟨", "🟩", "🟦", "🟪", "🟫", "⬛", "⬜", "◼️", "◻️", "◾", "◽", "▪️", "▫️", "🔶", "🔷", "🔸", "🔹", "🔺", "🔻", "💠", "🔘", "🔳", "🔲"]
    
    static let symbolsDictionary = ["Large Orange Diamond": "🔶", "Keycap Digit Six": "6️⃣", "Yellow Heart": "💛", "Red Question Mark": "❓", "Wavy Dash": "〰️", "Clockwise Vertical Arrows": "🔃", "Japanese “Secret” Button": "㊙️", "Chart Increasing with Yen": "💹", "Eject Button": "⏏️", "White Question Mark": "❔", "Dim Button": "🔅", "Japanese “Not Free of Charge” Button": "🈶", "Left-Right Arrow": "↔️", "Curly Loop": "➰", "Potable Water": "🚰", "Left Speech Bubble": "🗨️", "White Large Square": "⬜", "Place of Worship": "🛐", "Eight-Thirty": "🕣", "Hollow Red Circle": "⭕", "Leo": "♌", "Input Numbers": "🔢", "Japanese “Prohibited” Button": "🈲", "Stop Sign": "🛑", "Up Arrow": "⬆️", "No Mobile Phones": "📵", "Aquarius": "♒", "Hot Springs": "♨️", "No Smoking": "🚭", "Keycap Digit Zero": "0️⃣", "ID Button": "🆔", "Large Blue Diamond": "🔷", "Right Anger Bubble": "🗯️", "Top Arrow": "🔝", "Purple Circle": "🟣", "White Medium Square": "◻️", "Joker": "🃏", "Women’s Room": "🚺", "Input Latin Letters": "🔤", "Ophiuchus": "⛎", "Japanese “Vacancy” Button": "🈳", "Vibration Mode": "📳", "On! Arrow": "🔛", "Check Mark Button": "✅", "Litter in Bin Sign": "🚮", "Part Alternation Mark": "〽️", "Aries": "♈", "Bright Button": "🔆", "Japanese “Service Charge” Button": "🈂️", "Red Circle": "🔴", "Eight O’Clock": "🕗", "Yellow Square": "🟨", "Red Exclamation Mark": "❗", "Up-Left Arrow": "↖️", "Japanese “Bargain” Button": "🉐", "Red Triangle Pointed Down": "🔻", "Water Closet": "🚾", "Japanese “No Vacancy” Button": "🈵", "Nine-Thirty": "🕤", "Last Track Button": "⏮️", "One-Thirty": "🕜", "Antenna Bars": "📶", "Heart Exclamation": "❣️", "Up! Button": "🆙", "Heart Decoration": "💟", "Upwards Button": "🔼", "Pause Button": "⏸️", "Left Arrow": "⬅️", "Two O’Clock": "🕑", "Postal Horn": "📯", "Loudspeaker": "📢", "Double Exclamation Mark": "‼️", "Check Mark": "✔️", "Bell": "🔔", "Dotted Six-Pointed Star": "🔯", "Cool Button": "🆒", "Name Badge": "📛", "Pisces": "♓", "Radio Button": "🔘", "Japanese “Free of Charge” Button": "🈚", "Japanese “Monthly Amount” Button": "🈷️", "Currency Exchange": "💱", "Keycap Digit Three": "3️⃣", "White Square Button": "🔳", "Heart on Fire": "❤️‍🔥", "Peace Symbol": "☮️", "Black Heart": "🖤", "Exclamation Question Mark": "⁉️", "Keycap Digit Seven": "7️⃣", "Orthodox Cross": "☦️", "New Button": "🆕", "Eight-Pointed Star": "✴️", "Diamond Suit": "♦️", "Red Square": "🟥", "Black Square Button": "🔲", "Down-Right Arrow": "↘️", "Keycap Digit Eight": "8️⃣", "No Bicycles": "🚳", "Keycap Digit Four": "4️⃣", "Brown Circle": "🟤", "Black Large Square": "⬛", "Four-Thirty": "🕟", "Green Circle": "🟢", "Black Medium-Small Square": "◾", "Children Crossing": "🚸", "Musical Notes": "🎶", "Three-Thirty": "🕞", "Play or Pause Button": "⏯️", "Japanese “Congratulations” Button": "㊗️", "Infinity": "♾️", "Menorah": "🕎", "Keycap Digit Two": "2️⃣", "Men’s Room": "🚹", "Up-Down Arrow": "↕️", "Star of David": "✡️", "Fleur-de-lis": "⚜️", "Atom Symbol": "⚛️", "Speech Balloon": "💬", "Japanese “Discount” Button": "🈹", "Keycap Number Sign": "#️⃣", "Muted Speaker": "🔇", "Green Heart": "💚", "Megaphone": "📣", "Five O’Clock": "🕔", "Six-Thirty": "🕡", "Bell with Slash": "🔕", "No Pedestrians": "🚷", "Plus": "➕", "Heart Suit": "♥️", "Elevator": "🛗", "Keycap: 10": "🔟", "Broken Heart": "💔", "Purple Square": "🟪", "Six O’Clock": "🕕", "Reverse Button": "◀️", "Vs Button": "🆚", "Hundred Points": "💯", "Eight-Spoked Asterisk": "✳️", "Cross Mark": "❌", "White Flower": "💮", "Medical Symbol": "⚕️", "Anger Symbol": "💢", "Keycap Digit Nine": "9️⃣", "Input Latin Lowercase": "🔡", "Orange Square": "🟧", "Japanese “Reserved” Button": "🈯", "Yin Yang": "☯️", "Circled M": "Ⓜ️", "Fast Down Button": "⏬", "Small Blue Diamond": "🔹", "Thought Balloon": "💭", "White Exclamation Mark": "❕", "Female Sign": "♀️", "Blue Square": "🟦", "Two Hearts": "💕", "Twelve-Thirty": "🕧", "Eye in Speech Bubble": "👁️‍🗨️", "Blue Circle": "🔵", "Trident Emblem": "🔱", "Green Square": "🟩", "Keycap Digit One": "1️⃣", "Diamond with a Dot": "💠", "Brown Heart": "🤎", "Check Box with Check": "☑️", "Keycap Asterisk": "*️⃣", "Radioactive": "☢️", "Trade Mark": "™️", "Divide": "➗", "A Button (Blood Type)": "🅰️", "Japanese “Here” Button": "🈁", "Black Small Square": "▪️", "Play Button": "▶️", "White Circle": "⚪", "Downwards Button": "🔽", "Blue Heart": "💙", "Sparkling Heart": "💖", "Sparkle": "❇️", "Heart with Ribbon": "💝", "ATM Sign": "🏧", "Fast Up Button": "⏫", "Orange Circle": "🟠", "Two-Thirty": "🕝", "Zzz": "💤", "Up-Right Arrow": "↗️", "White Heart": "🤍", "Stop Button": "⏹️", "Wheelchair Symbol": "♿", "Left Arrow Curving Right": "↪️", "Sagittarius": "♐", "Mobile Phone Off": "📴", "Brown Square": "🟫", "Right Arrow Curving Up": "⤴️", "Warning": "⚠️", "Orange Heart": "🧡", "Free Button": "🆓", "Black Medium Square": "◼️", "No Littering": "🚯", "Non-Potable Water": "🚱", "Three O’Clock": "🕒", "Eleven O’Clock": "🕚", "Musical Note": "🎵", "Minus": "➖", "Red Heart": "❤️", "Libra": "♎", "Gemini": "♊", "No Entry": "⛔", "Heavy Equals Sign": "🟰", "Wheel of Dharma": "☸️", "Prohibited": "🚫", "Cyclone": "🌀", "Input Symbols": "🔣", "Repeat Button": "🔁", "Fast Reverse Button": "⏪", "Virgo": "♍", "Capricorn": "♑", "Purple Heart": "💜", "Scorpio": "♏", "Barber Pole": "💈", "Speaker Medium Volume": "🔉", "Japanese Symbol for Beginner": "🔰", "NG Button": "🆖", "Counterclockwise Arrows Button": "🔄", "Double Curly Loop": "➿", "Registered": "®️", "White Small Square": "▫️", "Recycling Symbol": "♻️", "Keycap Digit Five": "5️⃣", "Mahjong Red Dragon": "🀄", "Right Arrow Curving Down": "⤵️", "End Arrow": "🔚", "OK Button": "🆗", "O Button (Blood Type)": "🅾️", "Japanese “Open for Business” Button": "🈺", "Right Arrow Curving Left": "↩️", "White Medium-Small Square": "◽", "Heart with Arrow": "💘", "Japanese “Application” Button": "🈸", "Red Triangle Pointed Up": "🔺", "Taurus": "♉", "Mending Heart": "❤️‍🩹", "Five-Thirty": "🕠", "Soon Arrow": "🔜", "Baby Symbol": "🚼", "One O’Clock": "🕐", "CL Button": "🆑", "SOS Button": "🆘", "Japanese “Passing Grade” Button": "🈴", "Nine O’Clock": "🕘", "No One Under Eighteen": "🔞", "Ten-Thirty": "🕥", "Input Latin Uppercase": "🔠", "Growing Heart": "💗", "Back Arrow": "🔙", "Star and Crescent": "☪️", "Repeat Single Button": "🔂", "Fast-Forward Button": "⏩", "Seven O’Clock": "🕖", "Biohazard": "☣️", "Flower Playing Cards": "🎴", "Cinema": "🎦", "Spade Suit": "♠️", "Ten O’Clock": "🕙", "Cross Mark Button": "❎", "Revolving Hearts": "💞", "Cancer": "♋", "Shuffle Tracks Button": "🔀", "B Button (Blood Type)": "🅱️", "Eleven-Thirty": "🕦", "Latin Cross": "✝️", "Seven-Thirty": "🕢", "Twelve O’Clock": "🕛", "Black Circle": "⚫", "Om": "🕉️", "Speaker Low Volume": "🔈", "Down Arrow": "⬇️", "Copyright": "©️", "Male Sign": "♂️", "AB Button (Blood Type)": "🆎", "Next Track Button": "⏭️", "Information": "ℹ️", "Down-Left Arrow": "↙️", "Speaker High Volume": "🔊", "Beating Heart": "💓", "P Button": "🅿️", "Club Suit": "♣️", "Small Orange Diamond": "🔸", "Four O’Clock": "🕓", "Yellow Circle": "🟡", "Record Button": "⏺️", "Restroom": "🚻", "Right Arrow": "➡️", "Heavy Dollar Sign": "💲", "Japanese “Acceptable” Button": "🉑", "Multiply": "✖️"]
    
    static let flags = ["🏁", "🚩", "🎌", "🏴", "🏳️", "🏳️‍🌈", "🏳️‍⚧️", "🏴‍☠️", "🇦🇨", "🇦🇩", "🇦🇪", "🇦🇫", "🇦🇬", "🇦🇮", "🇦🇱", "🇦🇲", "🇦🇴", "🇦🇶", "🇦🇷", "🇦🇸", "🇦🇹", "🇦🇺", "🇦🇼", "🇦🇽", "🇦🇿", "🇧🇦", "🇧🇧", "🇧🇩", "🇧🇪", "🇧🇫", "🇧🇬", "🇧🇭", "🇧🇮", "🇧🇯", "🇧🇱", "🇧🇲", "🇧🇳", "🇧🇴", "🇧🇶", "🇧🇷", "🇧🇸", "🇧🇹", "🇧🇻", "🇧🇼", "🇧🇾", "🇧🇿", "🇨🇦", "🇨🇨", "🇨🇩", "🇨🇫", "🇨🇬", "🇨🇭", "🇨🇮", "🇨🇰", "🇨🇱", "🇨🇲", "🇨🇳", "🇨🇴", "🇨🇵", "🇨🇷", "🇨🇺", "🇨🇻", "🇨🇼", "🇨🇽", "🇨🇾", "🇨🇿", "🇩🇪", "🇩🇬", "🇩🇯", "🇩🇰", "🇩🇲", "🇩🇴", "🇩🇿", "🇪🇦", "🇪🇨", "🇪🇪", "🇪🇬", "🇪🇭", "🇪🇷", "🇪🇸", "🇪🇹", "🇪🇺", "🇫🇮", "🇫🇯", "🇫🇰", "🇫🇲", "🇫🇴", "🇫🇷", "🇬🇦", "🇬🇧", "🇬🇩", "🇬🇪", "🇬🇫", "🇬🇬", "🇬🇭", "🇬🇮", "🇬🇱", "🇬🇲", "🇬🇳", "🇬🇵", "🇬🇶", "🇬🇷", "🇬🇸", "🇬🇹", "🇬🇺", "🇬🇼", "🇬🇾", "🇭🇰", "🇭🇲", "🇭🇳", "🇭🇷", "🇭🇹", "🇭🇺", "🇮🇨", "🇮🇩", "🇮🇪", "🇮🇱", "🇮🇲", "🇮🇳", "🇮🇴", "🇮🇶", "🇮🇷", "🇮🇸", "🇮🇹", "🇯🇪", "🇯🇲", "🇯🇴", "🇯🇵", "🇰🇪", "🇰🇬", "🇰🇭", "🇰🇮", "🇰🇲", "🇰🇳", "🇰🇵", "🇰🇷", "🇰🇼", "🇰🇾", "🇰🇿", "🇱🇦", "🇱🇧", "🇱🇨", "🇱🇮", "🇱🇰", "🇱🇷", "🇱🇸", "🇱🇹", "🇱🇺", "🇱🇻", "🇱🇾", "🇲🇦", "🇲🇨", "🇲🇩", "🇲🇪", "🇲🇫", "🇲🇬", "🇲🇭", "🇲🇰", "🇲🇱", "🇲🇲", "🇲🇳", "🇲🇴", "🇲🇵", "🇲🇶", "🇲🇷", "🇲🇸", "🇲🇹", "🇲🇺", "🇲🇻", "🇲🇼", "🇲🇽", "🇲🇾", "🇲🇿", "🇳🇦", "🇳🇨", "🇳🇪", "🇳🇫", "🇳🇬", "🇳🇮", "🇳🇱", "🇳🇴", "🇳🇵", "🇳🇷", "🇳🇺", "🇳🇿", "🇴🇲", "🇵🇦", "🇵🇪", "🇵🇫", "🇵🇬", "🇵🇭", "🇵🇰", "🇵🇱", "🇵🇲", "🇵🇳", "🇵🇷", "🇵🇸", "🇵🇹", "🇵🇼", "🇵🇾", "🇶🇦", "🇷🇪", "🇷🇴", "🇷🇸", "🇷🇺", "🇷🇼", "🇸🇦", "🇸🇧", "🇸🇨", "🇸🇩", "🇸🇪", "🇸🇬", "🇸🇭", "🇸🇮", "🇸🇯", "🇸🇰", "🇸🇱", "🇸🇲", "🇸🇳", "🇸🇴", "🇸🇷", "🇸🇸", "🇸🇹", "🇸🇻", "🇸🇽", "🇸🇾", "🇸🇿", "🇹🇦", "🇹🇨", "🇹🇩", "🇹🇫", "🇹🇬", "🇹🇭", "🇹🇯", "🇹🇰", "🇹🇱", "🇹🇲", "🇹🇳", "🇹🇴", "🇹🇷", "🇹🇹", "🇹🇻", "🇹🇼", "🇹🇿", "🇺🇦", "🇺🇬", "🇺🇲", "🇺🇳", "🇺🇸", "🇺🇾", "🇺🇿", "🇻🇦", "🇻🇨", "🇻🇪", "🇻🇬", "🇻🇮", "🇻🇳", "🇻🇺", "🇼🇫", "🇼🇸", "🇽🇰", "🇾🇪", "🇾🇹", "🇿🇦", "🇿🇲", "🇿🇼", "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "🏴󠁧󠁢󠁷󠁬󠁳󠁿"]
    
    static let flagDictionary = ["Flag: Qatar": "🇶🇦", "Flag: Turkey": "🇹🇷", "Flag: Kazakhstan": "🇰🇿", "Flag: Czechia": "🇨🇿", "Flag: Malaysia": "🇲🇾", "Flag: Guatemala": "🇬🇹", "White Flag": "🏳️", "Chequered Flag": "🏁", "Flag: Cyprus": "🇨🇾", "Flag: Fiji": "🇫🇯", "Flag: Serbia": "🇷🇸", "Flag: Taiwan": "🇹🇼", "Flag: Montserrat": "🇲🇸", "Flag: Panama": "🇵🇦", "Flag: European Union": "🇪🇺", "Flag: Chad": "🇹🇩", "Flag: Peru": "🇵🇪", "Flag: Iraq": "🇮🇶", "Flag: South Korea": "🇰🇷", "Flag: Albania": "🇦🇱", "Flag: Samoa": "🇼🇸", "Pirate Flag": "🏴‍☠️", "Flag: China": "🇨🇳", "Flag: Zimbabwe": "🇿🇼", "Flag: Sri Lanka": "🇱🇰", "Flag: Marshall Islands": "🇲🇭", "Flag: Honduras": "🇭🇳", "Flag: Monaco": "🇲🇨", "Triangular Flag": "🚩", "Flag: Tuvalu": "🇹🇻", "Flag: Colombia": "🇨🇴", "Flag: Barbados": "🇧🇧", "Flag: Italy": "🇮🇹", "Flag: Equatorial Guinea": "🇬🇶", "Flag: Falkland Islands": "🇫🇰", "Flag: St. Pierre & Miquelon": "🇵🇲", "Flag: Tanzania": "🇹🇿", "Flag: Papua New Guinea": "🇵🇬", "Flag: Eswatini": "🇸🇿", "Flag: Tristan Da Cunha": "🇹🇦", "Flag: Burundi": "🇧🇮", "Flag: Faroe Islands": "🇫🇴", "Flag: Diego Garcia": "🇩🇬", "Flag: Maldives": "🇲🇻", "Flag: British Virgin Islands": "🇻🇬", "Flag: Mongolia": "🇲🇳", "Flag: Bulgaria": "🇧🇬", "Flag: New Caledonia": "🇳🇨", "Flag: Tokelau": "🇹🇰", "Flag: French Polynesia": "🇵🇫", "Flag: Spain": "🇪🇸", "Flag: St. Lucia": "🇱🇨", "Flag: Ceuta & Melilla": "🇪🇦", "Flag: Antigua & Barbuda": "🇦🇬", "Flag: Finland": "🇫🇮", "Flag: Kuwait": "🇰🇼", "Flag: Gibraltar": "🇬🇮", "Flag: Laos": "🇱🇦", "Flag: São Tomé & Príncipe": "🇸🇹", "Flag: Canada": "🇨🇦", "Flag: Sudan": "🇸🇩", "Flag: Vatican City": "🇻🇦", "Flag: Pakistan": "🇵🇰", "Flag: United Nations": "🇺🇳", "Flag: Antarctica": "🇦🇶", "Black Flag": "🏴", "Flag: Bosnia & Herzegovina": "🇧🇦", "Flag: Benin": "🇧🇯", "Flag: Eritrea": "🇪🇷", "Flag: France": "🇫🇷", "Flag: Ghana": "🇬🇭", "Flag: Niue": "🇳🇺", "Flag: Ukraine": "🇺🇦", "Flag: St. Vincent & Grenadines": "🇻🇨", "Flag: Senegal": "🇸🇳", "Flag: Djibouti": "🇩🇯", "Flag: Guadeloupe": "🇬🇵", "Flag: Japan": "🇯🇵", "Flag: Zambia": "🇿🇲", "Flag: Montenegro": "🇲🇪", "Flag: North Macedonia": "🇲🇰", "Flag: Curaçao": "🇨🇼", "Flag: Tunisia": "🇹🇳", "Flag: Germany": "🇩🇪", "Flag: Cuba": "🇨🇺", "Flag: Rwanda": "🇷🇼", "Flag: Sint Maarten": "🇸🇽", "Flag: Canary Islands": "🇮🇨", "Flag: Iran": "🇮🇷", "Flag: American Samoa": "🇦🇸", "Flag: Mali": "🇲🇱", "Flag: Turkmenistan": "🇹🇲", "Flag: New Zealand": "🇳🇿", "Flag: Bermuda": "🇧🇲", "Flag: Lebanon": "🇱🇧", "Flag: Botswana": "🇧🇼", "Flag: Norway": "🇳🇴", "Flag: South Sudan": "🇸🇸", "Flag: Jordan": "🇯🇴", "Flag: Uzbekistan": "🇺🇿", "Flag: Wallis & Futuna": "🇼🇫", "Flag: Aruba": "🇦🇼", "Flag: Andorra": "🇦🇩", "Flag: French Guiana": "🇬🇫", "Flag: Slovakia": "🇸🇰", "Flag: Myanmar (Burma)": "🇲🇲", "Flag: British Indian Ocean Territory": "🇮🇴", "Flag: Brunei": "🇧🇳", "Flag: Guyana": "🇬🇾", "Flag: Kenya": "🇰🇪", "Flag: St. Kitts & Nevis": "🇰🇳", "Flag: Suriname": "🇸🇷", "Flag: Timor-Leste": "🇹🇱", "Flag: Sierra Leone": "🇸🇱", "Flag: Denmark": "🇩🇰", "Flag: Western Sahara": "🇪🇭", "Flag: Ecuador": "🇪🇨", "Flag: Congo - Kinshasa": "🇨🇩", "Flag: Luxembourg": "🇱🇺", "Flag: Togo": "🇹🇬", "Flag: Madagascar": "🇲🇬", "Flag: Hong Kong SAR China": "🇭🇰", "Flag: Cocos (Keeling) Islands": "🇨🇨", "Flag: San Marino": "🇸🇲", "Crossed Flags": "🎌", "Flag: Palau": "🇵🇼", "Flag: Haiti": "🇭🇹", "Flag: Chile": "🇨🇱", "Flag: Martinique": "🇲🇶", "Flag: Poland": "🇵🇱", "Flag: Argentina": "🇦🇷", "Flag: Angola": "🇦🇴", "Flag: Netherlands": "🇳🇱", "Flag: Nepal": "🇳🇵", "Flag: Kyrgyzstan": "🇰🇬", "Flag: Bahamas": "🇧🇸", "Flag: Russia": "🇷🇺", "Flag: Mauritius": "🇲🇺", "Flag: Scotland": "🏴󠁧󠁢󠁳󠁣󠁴󠁿", "Flag: Uruguay": "🇺🇾", "Flag: Turks & Caicos Islands": "🇹🇨", "Flag: Singapore": "🇸🇬", "Flag: Libya": "🇱🇾", "Flag: Israel": "🇮🇱", "Flag: Iceland": "🇮🇸", "Flag: St. Helena": "🇸🇭", "Flag: Switzerland": "🇨🇭", "Flag: Isle of Man": "🇮🇲", "Flag: Liberia": "🇱🇷", "Flag: Mozambique": "🇲🇿", "Flag: Nigeria": "🇳🇬", "Flag: Trinidad & Tobago": "🇹🇹", "Flag: United Kingdom": "🇬🇧", "Flag: Jersey": "🇯🇪", "Flag: Belarus": "🇧🇾", "Flag: Guinea": "🇬🇳", "Flag: Wales": "🏴󠁧󠁢󠁷󠁬󠁳󠁿", "Flag: Malawi": "🇲🇼", "Flag: Belgium": "🇧🇪", "Flag: Afghanistan": "🇦🇫", "Flag: Venezuela": "🇻🇪", "Flag: Niger": "🇳🇪", "Flag: Morocco": "🇲🇦", "Flag: Brazil": "🇧🇷", "Flag: Vanuatu": "🇻🇺", "Transgender Flag": "🏳️‍⚧️", "Flag: Cambodia": "🇰🇭", "Flag: Réunion": "🇷🇪", "Flag: Hungary": "🇭🇺", "Flag: Congo - Brazzaville": "🇨🇬", "Flag: United Arab Emirates": "🇦🇪", "Flag: Yemen": "🇾🇪", "Flag: Austria": "🇦🇹", "Flag: United States": "🇺🇸", "Flag: Belize": "🇧🇿", "Flag: Romania": "🇷🇴", "Flag: Estonia": "🇪🇪", "Flag: Solomon Islands": "🇸🇧", "Flag: Mayotte": "🇾🇹", "Flag: Heard & McDonald Islands": "🇭🇲", "Flag: El Salvador": "🇸🇻", "Flag: Guam": "🇬🇺", "Flag: Pitcairn Islands": "🇵🇳", "Flag: Costa Rica": "🇨🇷", "Flag: Latvia": "🇱🇻", "Flag: Namibia": "🇳🇦", "Flag: Uganda": "🇺🇬", "Flag: Cayman Islands": "🇰🇾", "Flag: Jamaica": "🇯🇲", "Flag: Guinea-Bissau": "🇬🇼", "Flag: Christmas Island": "🇨🇽", "Flag: Burkina Faso": "🇧🇫", "Flag: Bahrain": "🇧🇭", "Flag: Gambia": "🇬🇲", "Flag: Puerto Rico": "🇵🇷", "Flag: Svalbard & Jan Mayen": "🇸🇯", "Flag: Australia": "🇦🇺", "Flag: India": "🇮🇳", "Flag: Somalia": "🇸🇴", "Flag: St. Barthélemy": "🇧🇱", "Flag: Slovenia": "🇸🇮", "Flag: Indonesia": "🇮🇩", "Flag: Moldova": "🇲🇩", "Flag: Central African Republic": "🇨🇫", "Flag: Norfolk Island": "🇳🇫", "Flag: Malta": "🇲🇹", "Flag: Oman": "🇴🇲", "Flag: Tonga": "🇹🇴", "Rainbow Flag": "🏳️‍🌈", "Flag: Algeria": "🇩🇿", "Flag: Seychelles": "🇸🇨", "Flag: Kosovo": "🇽🇰", "Flag: Palestinian Territories": "🇵🇸", "Flag: Micronesia": "🇫🇲", "Flag: Cook Islands": "🇨🇰", "Flag: Tajikistan": "🇹🇯", "Flag: Azerbaijan": "🇦🇿", "Flag: Cape Verde": "🇨🇻", "Flag: Lithuania": "🇱🇹", "Flag: U.S. Virgin Islands": "🇻🇮", "Flag: Armenia": "🇦🇲", "Flag: North Korea": "🇰🇵", "Flag: French Southern Territories": "🇹🇫", "Flag: South Africa": "🇿🇦", "Flag: Portugal": "🇵🇹", "Flag: Syria": "🇸🇾", "Flag: Kiribati": "🇰🇮", "Flag: Nauru": "🇳🇷", "Flag: Ascension Island": "🇦🇨", "Flag: Grenada": "🇬🇩", "Flag: Saudi Arabia": "🇸🇦", "Flag: Paraguay": "🇵🇾", "Flag: Liechtenstein": "🇱🇮", "Flag: Sweden": "🇸🇪", "Flag: Dominican Republic": "🇩🇴", "Flag: Philippines": "🇵🇭", "Flag: St. Martin": "🇲🇫", "Flag: Mexico": "🇲🇽", "Flag: Anguilla": "🇦🇮", "Flag: Bhutan": "🇧🇹", "Flag: Bangladesh": "🇧🇩", "Flag: Clipperton Island": "🇨🇵", "Flag: Nicaragua": "🇳🇮", "Flag: Egypt": "🇪🇬", "Flag: Gabon": "🇬🇦", "Flag: Cameroon": "🇨🇲", "Flag: Caribbean Netherlands": "🇧🇶", "Flag: Côte d’Ivoire": "🇨🇮", "Flag: Bolivia": "🇧🇴", "Flag: Comoros": "🇰🇲", "Flag: Ireland": "🇮🇪", "Flag: Croatia": "🇭🇷", "Flag: Dominica": "🇩🇲", "Flag: Ethiopia": "🇪🇹", "Flag: Lesotho": "🇱🇸", "Flag: Guernsey": "🇬🇬", "Flag: Bouvet Island": "🇧🇻", "Flag: Thailand": "🇹🇭", "Flag: U.S. Outlying Islands": "🇺🇲", "Flag: Åland Islands": "🇦🇽", "Flag: England": "🏴󠁧󠁢󠁥󠁮󠁧󠁿", "Flag: Mauritania": "🇲🇷", "Flag: South Georgia & South Sandwich Islands": "🇬🇸", "Flag: Northern Mariana Islands": "🇲🇵", "Flag: Greenland": "🇬🇱", "Flag: Greece": "🇬🇷", "Flag: Macao Sar China": "🇲🇴", "Flag: Vietnam": "🇻🇳", "Flag: Georgia": "🇬🇪"]
    
     var all = [String]()
}
