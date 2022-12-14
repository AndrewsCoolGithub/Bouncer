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


final class EmojiGallery{
    
var people = """
๐ Grinning Face
๐ Grinning Face with Big Eyes
๐ Grinning Face with Smiling Eyes
๐ Beaming Face with Smiling Eyes
๐ Grinning Squinting Face
๐ Grinning Face with Sweat
๐คฃ Rolling on the Floor Laughing
๐ Face with Tears of Joy
๐ Slightly Smiling Face
๐ Upside-Down Face
๐ซ  Melting Face
๐ Winking Face
๐ Smiling Face with Smiling Eyes
๐ Smiling Face with Halo
๐ฅฐ Smiling Face with Hearts
๐ Smiling Face with Heart-Eyes
๐คฉ Star-Struck
๐ Face Blowing a Kiss
๐ Kissing Face
โบ๏ธ Smiling Face
๐ Kissing Face with Closed Eyes
๐ Kissing Face with Smiling Eyes
๐ฅฒ Smiling Face with Tear
๐ Face Savoring Food
๐ Face with Tongue
๐ Winking Face with Tongue
๐คช Zany Face
๐ Squinting Face with Tongue
๐ค Money-Mouth Face
๐ค Smiling Face with Open Hands
๐คญ Face with Hand Over Mouth
๐ซข Face with Open Eyes and Hand Over Mouth
๐ซฃ Face with Peeking Eye
๐คซ Shushing Face
๐ค Thinking Face
๐ซก Saluting Face
๐ค Zipper-Mouth Face
๐คจ Face with Raised Eyebrow
๐ Neutral Face
๐ Expressionless Face
๐ถ Face Without Mouth
๐ซฅ Dotted Line Face
๐ถโ๐ซ๏ธ Face in Clouds
๐ Smirking Face
๐ Unamused Face
๐ Face with Rolling Eyes
๐ฌ Grimacing Face
๐ฎโ๐จ Face Exhaling
๐คฅ Lying Face
๐ Relieved Face
๐ Pensive Face
๐ช Sleepy Face
๐คค Drooling Face
๐ด Sleeping Face
๐ท Face with Medical Mask
๐ค Face with Thermometer
๐ค Face with Head-Bandage
๐คข Nauseated Face
๐คฎ Face Vomiting
๐คง Sneezing Face
๐ฅต Hot Face
๐ฅถ Cold Face
๐ฅด Woozy Face
๐ต Face with Crossed-Out Eyes
๐ตโ๐ซ Face with Spiral Eyes
๐คฏ Exploding Head
๐ค  Cowboy Hat Face
๐ฅณ Partying Face
๐ฅธ Disguised Face
๐ Smiling Face with Sunglasses
๐ค Nerd Face
๐ง Face with Monocle
๐ Confused Face
๐ซค Face with Diagonal Mouth
๐ Worried Face
๐ Slightly Frowning Face
โน๏ธ Frowning Face
๐ฎ Face with Open Mouth
๐ฏ Hushed Face
๐ฒ Astonished Face
๐ณ Flushed Face
๐ฅบ Pleading Face
๐ฅน Face Holding Back Tears
๐ฆ Frowning Face with Open Mouth
๐ง Anguished Face
๐จ Fearful Face
๐ฐ Anxious Face with Sweat
๐ฅ Sad but Relieved Face
๐ข Crying Face
๐ญ Loudly Crying Face
๐ฑ Face Screaming in Fear
๐ Confounded Face
๐ฃ Persevering Face
๐ Disappointed Face
๐ Downcast Face with Sweat
๐ฉ Weary Face
๐ซ Tired Face
๐ฅฑ Yawning Face
๐ค Face with Steam From Nose
๐ก Enraged Face
๐  Angry Face
๐คฌ Face with Symbols on Mouth
๐ Smiling Face with Horns
๐ฟ Angry Face with Horns
๐ Skull
โ ๏ธ Skull and Crossbones
๐ฉ Pile of Poo
๐คก Clown Face
๐น Ogre
๐บ Goblin
๐ป Ghost
๐ฝ Alien
๐พ Alien Monster
๐ค Robot
๐บ Grinning Cat
๐ธ Grinning Cat with Smiling Eyes
๐น Cat with Tears of Joy
๐ป Smiling Cat with Heart-Eyes
๐ผ Cat with Wry Smile
๐ฝ Kissing Cat
๐ Weary Cat
๐ฟ Crying Cat
๐พ Pouting Cat
๐ Kiss Mark
๐ Waving Hand
๐ค Raised Back of Hand
๐๏ธ Hand with Fingers Splayed
โ Raised Hand
๐ Vulcan Salute
๐ซฑ Rightwards Hand
๐ซฒ Leftwards Hand
๐ซณ Palm Down Hand
๐ซด Palm Up Hand
๐ OK Hand
๐ค Pinched Fingers
๐ค Pinching Hand
โ๏ธ Victory Hand
๐ค Crossed Fingers
๐ซฐ Hand with Index Finger and Thumb Crossed
๐ค Love-You Gesture
๐ค Sign of the Horns
๐ค Call Me Hand
๐ Backhand Index Pointing Left
๐ Backhand Index Pointing Right
๐ Backhand Index Pointing Up
๐ Middle Finger
๐ Backhand Index Pointing Down
โ๏ธ Index Pointing Up
๐ซต Index Pointing at the Viewer
๐ Thumbs Up
๐ Thumbs Down
โ Raised Fist
๐ Oncoming Fist
๐ค Left-Facing Fist
๐ค Right-Facing Fist
๐ Clapping Hands
๐ Raising Hands
๐ซถ Heart Hands
๐ Open Hands
๐คฒ Palms Up Together
๐ค Handshake
๐ Folded Hands
โ๏ธ Writing Hand
๐ Nail Polish
๐คณ Selfie
๐ช Flexed Biceps
๐ฆพ Mechanical Arm
๐ฆฟ Mechanical Leg
๐ฆต Leg
๐ฆถ Foot
๐ Ear
๐ฆป Ear with Hearing Aid
๐ Nose
๐ง  Brain
๐ซ Anatomical Heart
๐ซ Lungs
๐ฆท Tooth
๐ฆด Bone
๐ Eyes
๐๏ธ Eye
๐ Tongue
๐ Mouth
๐ซฆ Biting Lip
๐ถ Baby
๐ง Child
๐ฆ Boy
๐ง Girl
๐ง Person
๐ฑ Person: Blond Hair
๐จ Man
๐ง Person: Beard
๐จโ๐ฆฐ Man: Red Hair
๐จโ๐ฆฑ Man: Curly Hair
๐จโ๐ฆณ Man: White Hair
๐จโ๐ฆฒ Man: Bald
๐ฉ Woman
๐ฉโ๐ฆฐ Woman: Red Hair
๐งโ๐ฆฐ Person: Red Hair
๐ฉโ๐ฆฑ Woman: Curly Hair
๐งโ๐ฆฑ Person: Curly Hair
๐ฉโ๐ฆณ Woman: White Hair
๐งโ๐ฆณ Person: White Hair
๐ฉโ๐ฆฒ Woman: Bald
๐งโ๐ฆฒ Person: Bald
๐ฑโโ๏ธ Woman: Blond Hair
๐ฑโโ๏ธ Man: Blond Hair
๐ง Older Person
๐ด Old Man
๐ต Old Woman
๐ Person Frowning
๐โโ๏ธ Man Frowning
๐โโ๏ธ Woman Frowning
๐ Person Pouting
๐โโ๏ธ Man Pouting
๐โโ๏ธ Woman Pouting
๐ Person Gesturing No
๐โโ๏ธ Man Gesturing No
๐โโ๏ธ Woman Gesturing No
๐ Person Gesturing OK
๐โโ๏ธ Man Gesturing OK
๐โโ๏ธ Woman Gesturing OK
๐ Person Tipping Hand
๐โโ๏ธ Man Tipping Hand
๐โโ๏ธ Woman Tipping Hand
๐ Person Raising Hand
๐โโ๏ธ Man Raising Hand
๐โโ๏ธ Woman Raising Hand
๐ง Deaf Person
๐งโโ๏ธ Deaf Man
๐งโโ๏ธ Deaf Woman
๐ Person Bowing
๐โโ๏ธ Man Bowing
๐โโ๏ธ Woman Bowing
๐คฆ Person Facepalming
๐คฆโโ๏ธ Man Facepalming
๐คฆโโ๏ธ Woman Facepalming
๐คท Person Shrugging
๐คทโโ๏ธ Man Shrugging
๐คทโโ๏ธ Woman Shrugging
๐งโโ๏ธ Health Worker
๐จโโ๏ธ Man Health Worker
๐ฉโโ๏ธ Woman Health Worker
๐งโ๐ Student
๐จโ๐ Man Student
๐ฉโ๐ Woman Student
๐งโ๐ซ Teacher
๐จโ๐ซ Man Teacher
๐ฉโ๐ซ Woman Teacher
๐งโโ๏ธ Judge
๐จโโ๏ธ Man Judge
๐ฉโโ๏ธ Woman Judge
๐งโ๐พ Farmer
๐จโ๐พ Man Farmer
๐ฉโ๐พ Woman Farmer
๐งโ๐ณ Cook
๐จโ๐ณ Man Cook
๐ฉโ๐ณ Woman Cook
๐งโ๐ง Mechanic
๐จโ๐ง Man Mechanic
๐ฉโ๐ง Woman Mechanic
๐งโ๐ญ Factory Worker
๐จโ๐ญ Man Factory Worker
๐ฉโ๐ญ Woman Factory Worker
๐งโ๐ผ Office Worker
๐จโ๐ผ Man Office Worker
๐ฉโ๐ผ Woman Office Worker
๐งโ๐ฌ Scientist
๐จโ๐ฌ Man Scientist
๐ฉโ๐ฌ Woman Scientist
๐งโ๐ป Technologist
๐จโ๐ป Man Technologist
๐ฉโ๐ป Woman Technologist
๐งโ๐ค Singer
๐จโ๐ค Man Singer
๐ฉโ๐ค Woman Singer
๐งโ๐จ Artist
๐จโ๐จ Man Artist
๐ฉโ๐จ Woman Artist
๐งโโ๏ธ Pilot
๐จโโ๏ธ Man Pilot
๐ฉโโ๏ธ Woman Pilot
๐งโ๐ Astronaut
๐จโ๐ Man Astronaut
๐ฉโ๐ Woman Astronaut
๐งโ๐ Firefighter
๐จโ๐ Man Firefighter
๐ฉโ๐ Woman Firefighter
๐ฎ Police Officer
๐ฎโโ๏ธ Man Police Officer
๐ฎโโ๏ธ Woman Police Officer
๐ต๏ธ Detective
๐ต๏ธโโ๏ธ Man Detective
๐ต๏ธโโ๏ธ Woman Detective
๐ Guard
๐โโ๏ธ Man Guard
๐โโ๏ธ Woman Guard
๐ฅท Ninja
๐ท Construction Worker
๐ทโโ๏ธ Man Construction Worker
๐ทโโ๏ธ Woman Construction Worker
๐ซ Person with Crown
๐คด Prince
๐ธ Princess
๐ณ Person Wearing Turban
๐ณโโ๏ธ Man Wearing Turban
๐ณโโ๏ธ Woman Wearing Turban
๐ฒ Person with Skullcap
๐ง Woman with Headscarf
๐คต Person in Tuxedo
๐คตโโ๏ธ Man in Tuxedo
๐คตโโ๏ธ Woman in Tuxedo
๐ฐ Person with Veil
๐ฐโโ๏ธ Man with Veil
๐ฐโโ๏ธ Woman with Veil
๐คฐ Pregnant Woman
๐ซ Pregnant Man
๐ซ Pregnant Person
๐คฑ Breast-Feeding
๐ฉโ๐ผ Woman Feeding Baby
๐จโ๐ผ Man Feeding Baby
๐งโ๐ผ Person Feeding Baby
๐ผ Baby Angel
๐ Santa Claus
๐คถ Mrs. Claus
๐งโ๐ Mx Claus
๐ฆธ Superhero
๐ฆธโโ๏ธ Man Superhero
๐ฆธโโ๏ธ Woman Superhero
๐ฆน Supervillain
๐ฆนโโ๏ธ Man Supervillain
๐ฆนโโ๏ธ Woman Supervillain
๐ง Mage
๐งโโ๏ธ Man Mage
๐งโโ๏ธ Woman Mage
๐ง Fairy
๐งโโ๏ธ Man Fairy
๐งโโ๏ธ Woman Fairy
๐ง Vampire
๐งโโ๏ธ Man Vampire
๐งโโ๏ธ Woman Vampire
๐ง Merperson
๐งโโ๏ธ Merman
๐งโโ๏ธ Mermaid
๐ง Elf
๐งโโ๏ธ Man Elf
๐งโโ๏ธ Woman Elf
๐ง Genie
๐งโโ๏ธ Man Genie
๐งโโ๏ธ Woman Genie
๐ง Zombie
๐งโโ๏ธ Man Zombie
๐งโโ๏ธ Woman Zombie
๐ง Troll
๐ Person Getting Massage
๐โโ๏ธ Man Getting Massage
๐โโ๏ธ Woman Getting Massage
๐ Person Getting Haircut
๐โโ๏ธ Man Getting Haircut
๐โโ๏ธ Woman Getting Haircut
๐ถ Person Walking
๐ถโโ๏ธ Man Walking
๐ถโโ๏ธ Woman Walking
๐ง Person Standing
๐งโโ๏ธ Man Standing
๐งโโ๏ธ Woman Standing
๐ง Person Kneeling
๐งโโ๏ธ Man Kneeling
๐งโโ๏ธ Woman Kneeling
๐งโ๐ฆฏ Person with White Cane
๐จโ๐ฆฏ Man with White Cane
๐ฉโ๐ฆฏ Woman with White Cane
๐งโ๐ฆผ Person in Motorized Wheelchair
๐จโ๐ฆผ Man in Motorized Wheelchair
๐ฉโ๐ฆผ Woman in Motorized Wheelchair
๐งโ๐ฆฝ Person in Manual Wheelchair
๐จโ๐ฆฝ Man in Manual Wheelchair
๐ฉโ๐ฆฝ Woman in Manual Wheelchair
๐ Person Running
๐โโ๏ธ Man Running
๐โโ๏ธ Woman Running
๐ Woman Dancing
๐บ Man Dancing
๐ด๏ธ Person in Suit Levitating
๐ฏ People with Bunny Ears
๐ฏโโ๏ธ Men with Bunny Ears
๐ฏโโ๏ธ Women with Bunny Ears
๐ง Person in Steamy Room
๐งโโ๏ธ Man in Steamy Room
๐งโโ๏ธ Woman in Steamy Room
๐ง Person in Lotus Position
๐งโ๐คโ๐ง People Holding Hands
๐ญ Women Holding Hands
๐ซ Woman and Man Holding Hands
๐ฌ Men Holding Hands
๐ Kiss
๐ฉโโค๏ธโ๐โ๐จ Kiss: Woman, Man
๐จโโค๏ธโ๐โ๐จ Kiss: Man, Man
๐ฉโโค๏ธโ๐โ๐ฉ Kiss: Woman, Woman
๐ Couple with Heart
๐ฉโโค๏ธโ๐จ Couple with Heart: Woman, Man
๐จโโค๏ธโ๐จ Couple with Heart: Man, Man
๐ฉโโค๏ธโ๐ฉ Couple with Heart: Woman, Woman
๐ช Family
๐จโ๐ฉโ๐ฆ Family: Man, Woman, Boy
๐จโ๐ฉโ๐ง Family: Man, Woman, Girl
๐จโ๐ฉโ๐งโ๐ฆ Family: Man, Woman, Girl, Boy
๐จโ๐ฉโ๐ฆโ๐ฆ Family: Man, Woman, Boy, Boy
๐จโ๐ฉโ๐งโ๐ง Family: Man, Woman, Girl, Girl
๐จโ๐จโ๐ฆ Family: Man, Man, Boy
๐จโ๐จโ๐ง Family: Man, Man, Girl
๐จโ๐จโ๐งโ๐ฆ Family: Man, Man, Girl, Boy
๐จโ๐จโ๐ฆโ๐ฆ Family: Man, Man, Boy, Boy
๐จโ๐จโ๐งโ๐ง Family: Man, Man, Girl, Girl
๐ฉโ๐ฉโ๐ฆ Family: Woman, Woman, Boy
๐ฉโ๐ฉโ๐ง Family: Woman, Woman, Girl
๐ฉโ๐ฉโ๐งโ๐ฆ Family: Woman, Woman, Girl, Boy
๐ฉโ๐ฉโ๐ฆโ๐ฆ Family: Woman, Woman, Boy, Boy
๐ฉโ๐ฉโ๐งโ๐ง Family: Woman, Woman, Girl, Girl
๐จโ๐ฆ Family: Man, Boy
๐จโ๐ฆโ๐ฆ Family: Man, Boy, Boy
๐จโ๐ง Family: Man, Girl
๐จโ๐งโ๐ฆ Family: Man, Girl, Boy
๐จโ๐งโ๐ง Family: Man, Girl, Girl
๐ฉโ๐ฆ Family: Woman, Boy
๐ฉโ๐ฆโ๐ฆ Family: Woman, Boy, Boy
๐ฉโ๐ง Family: Woman, Girl
๐ฉโ๐งโ๐ฆ Family: Woman, Girl, Boy
๐ฉโ๐งโ๐ง Family: Woman, Girl, Girl
๐ฃ๏ธ Speaking Head
๐ค Bust in Silhouette
๐ฅ Busts in Silhouette
๐ซ People Hugging
๐ฃ Footprints
๐งณ Luggage
๐ Closed Umbrella
โ๏ธ Umbrella
๐ Jack-O-Lantern
๐งต Thread
๐ Glasses
๐ถ๏ธ Sunglasses
๐ฅฝ Goggles
๐ฅผ Lab Coat
๐ฆบ Safety Vest
๐ Necktie
๐ T-Shirt
๐ Jeans
๐งฃ Scarf
๐งค Gloves
๐งฅ Coat
๐งฆ Socks
๐ Dress
๐ Kimono
๐ฅป Sari
๐ฉฑ One-Piece Swimsuit
๐ฉฒ Briefs
๐ฉณ Shorts
๐ Bikini
๐ Womanโs Clothes
๐ Purse
๐ Handbag
๐ Clutch Bag
๐ Backpack
๐ฉด Thong Sandal
๐ Manโs Shoe
๐ Running Shoe
๐ฅพ Hiking Boot
๐ฅฟ Flat Shoe
๐  High-Heeled Shoe
๐ก Womanโs Sandal
๐ฉฐ Ballet Shoes
๐ข Womanโs Boot
๐ Crown
๐ Womanโs Hat
๐ฉ Top Hat
๐ Graduation Cap
๐งข Billed Cap
๐ช Military Helmet
โ๏ธ Rescue Workerโs Helmet
๐ Lipstick
๐ Ring
๐ผ Briefcase
๐ฉธ Drop of Blood
๐ See-No-Evil Monkey
๐ Hear-No-Evil Monkey
๐ Speak-No-Evil Monkey
๐ฅ Collision
๐ซ Dizzy
๐ฆ Sweat Droplets
๐จ Dashing Away
๐ต Monkey Face
๐ Monkey
๐ฆ Gorilla
๐ฆง Orangutan
๐ถ Dog Face
๐ Dog
๐ฆฎ Guide Dog
๐โ๐ฆบ Service Dog
๐ฉ Poodle
๐บ Wolf
๐ฆ Fox
๐ฆ Raccoon
๐ฑ Cat Face
๐ Cat
๐โโฌ Black Cat
๐ฆ Lion
๐ฏ Tiger Face
๐ Tiger
๐ Leopard
๐ด Horse Face
๐ Horse
๐ฆ Unicorn
๐ฆ Zebra
๐ฆ Deer
๐ฆฌ Bison
๐ฎ Cow Face
๐ Ox
๐ Water Buffalo
๐ Cow
๐ท Pig Face
๐ Pig
๐ Boar
๐ฝ Pig Nose
๐ Ram
๐ Ewe
๐ Goat
๐ช Camel
๐ซ Two-Hump Camel
๐ฆ Llama
๐ฆ Giraffe
๐ Elephant
๐ฆฃ Mammoth
๐ฆ Rhinoceros
๐ฆ Hippopotamus
๐ญ Mouse Face
๐ Mouse
๐ Rat
๐น Hamster
๐ฐ Rabbit Face
๐ Rabbit
๐ฟ๏ธ Chipmunk
๐ฆซ Beaver
๐ฆ Hedgehog
๐ฆ Bat
๐ป Bear
๐ปโโ๏ธ Polar Bear
๐จ Koala
๐ผ Panda
๐ฆฅ Sloth
๐ฆฆ Otter
๐ฆจ Skunk
๐ฆ Kangaroo
๐ฆก Badger
๐พ Paw Prints
๐ฆ Turkey
๐ Chicken
๐ Rooster
๐ฃ Hatching Chick
๐ค Baby Chick
๐ฅ Front-Facing Baby Chick
๐ฆ Bird
๐ง Penguin
๐๏ธ Dove
๐ฆ Eagle
๐ฆ Duck
๐ฆข Swan
๐ฆ Owl
๐ฆค Dodo
๐ชถ Feather
๐ฆฉ Flamingo
๐ฆ Peacock
๐ฆ Parrot
๐ธ Frog
๐ Crocodile
๐ข Turtle
๐ฆ Lizard
๐ Snake
๐ฒ Dragon Face
๐ Dragon
๐ฆ Sauropod
๐ฆ T-Rex
๐ณ Spouting Whale
๐ Whale
๐ฌ Dolphin
๐ฆญ Seal
๐ Fish
๐  Tropical Fish
๐ก Blowfish
๐ฆ Shark
๐ Octopus
๐ Spiral Shell
๐ชธ Coral
๐ Snail
๐ฆ Butterfly
๐ Bug
๐ Ant
๐ Honeybee
๐ชฒ Beetle
๐ Lady Beetle
๐ฆ Cricket
๐ชณ Cockroach
๐ท๏ธ Spider
๐ธ๏ธ Spider Web
๐ฆ Scorpion
๐ฆ Mosquito
๐ชฐ Fly
๐ชฑ Worm
๐ฆ  Microbe
๐ Bouquet
๐ธ Cherry Blossom
๐ฎ White Flower
๐ชท Lotus
๐ต๏ธ Rosette
๐น Rose
๐ฅ Wilted Flower
๐บ Hibiscus
๐ป Sunflower
๐ผ Blossom
๐ท Tulip
๐ฑ Seedling
๐ชด Potted Plant
๐ฒ Evergreen Tree
๐ณ Deciduous Tree
๐ด Palm Tree
๐ต Cactus
๐พ Sheaf of Rice
๐ฟ Herb
โ๏ธ Shamrock
๐ Four Leaf Clover
๐ Maple Leaf
๐ Fallen Leaf
๐ Leaf Fluttering in Wind
๐ชน Empty Nest
๐ชบ Nest with Eggs
๐ Mushroom
๐ฐ Chestnut
๐ฆ Crab
๐ฆ Lobster
๐ฆ Shrimp
๐ฆ Squid
๐ Globe Showing Europe-Africa
๐ Globe Showing Americas
๐ Globe Showing Asia-Australia
๐ Globe with Meridians
๐ชจ Rock
๐ New Moon
๐ Waxing Crescent Moon
๐ First Quarter Moon
๐ Waxing Gibbous Moon
๐ Full Moon
๐ Waning Gibbous Moon
๐ Last Quarter Moon
๐ Waning Crescent Moon
๐ Crescent Moon
๐ New Moon Face
๐ First Quarter Moon Face
๐ Last Quarter Moon Face
โ๏ธ Sun
๐ Full Moon Face
๐ Sun with Face
โญ Star
๐ Glowing Star
๐  Shooting Star
โ๏ธ Cloud
โ Sun Behind Cloud
โ๏ธ Cloud with Lightning and Rain
๐ค๏ธ Sun Behind Small Cloud
๐ฅ๏ธ Sun Behind Large Cloud
๐ฆ๏ธ Sun Behind Rain Cloud
๐ง๏ธ Cloud with Rain
๐จ๏ธ Cloud with Snow
๐ฉ๏ธ Cloud with Lightning
๐ช๏ธ Tornado
๐ซ๏ธ Fog
๐ฌ๏ธ Wind Face
๐ Rainbow
โ Umbrella with Rain Drops
โก High Voltage
โ๏ธ Snowflake
โ๏ธ Snowman
โ Snowman Without Snow
โ๏ธ Comet
๐ฅ Fire
๐ง Droplet
๐ Water Wave
๐ Christmas Tree
โจ Sparkles
๐ Tanabata Tree
๐ Pine Decoration
๐ซง Bubbles
๐ Grapes
๐ Melon
๐ Watermelon
๐ Tangerine
๐ Lemon
๐ Banana
๐ Pineapple
๐ฅญ Mango
๐ Red Apple
๐ Green Apple
๐ Pear
๐ Peach
๐ Cherries
๐ Strawberry
๐ซ Blueberries
๐ฅ Kiwi Fruit
๐ Tomato
๐ซ Olive
๐ฅฅ Coconut
๐ฅ Avocado
๐ Eggplant
๐ฅ Potato
๐ฅ Carrot
๐ฝ Ear of Corn
๐ถ๏ธ Hot Pepper
๐ซ Bell Pepper
๐ฅ Cucumber
๐ฅฌ Leafy Green
๐ฅฆ Broccoli
๐ง Garlic
๐ง Onion
๐ Mushroom
๐ฅ Peanuts
๐ซ Beans
๐ฐ Chestnut
๐ Bread
๐ฅ Croissant
๐ฅ Baguette Bread
๐ซ Flatbread
๐ฅจ Pretzel
๐ฅฏ Bagel
๐ฅ Pancakes
๐ง Waffle
๐ง Cheese Wedge
๐ Meat on Bone
๐ Poultry Leg
๐ฅฉ Cut of Meat
๐ฅ Bacon
๐ Hamburger
๐ French Fries
๐ Pizza
๐ญ Hot Dog
๐ฅช Sandwich
๐ฎ Taco
๐ฏ Burrito
๐ซ Tamale
๐ฅ Stuffed Flatbread
๐ง Falafel
๐ฅ Egg
๐ณ Cooking
๐ฅ Shallow Pan of Food
๐ฒ Pot of Food
๐ซ Fondue
๐ฅฃ Bowl with Spoon
๐ฅ Green Salad
๐ฟ Popcorn
๐ง Butter
๐ง Salt
๐ฅซ Canned Food
๐ฑ Bento Box
๐ Rice Cracker
๐ Rice Ball
๐ Cooked Rice
๐ Curry Rice
๐ Steaming Bowl
๐ Spaghetti
๐  Roasted Sweet Potato
๐ข Oden
๐ฃ Sushi
๐ค Fried Shrimp
๐ฅ Fish Cake with Swirl
๐ฅฎ Moon Cake
๐ก Dango
๐ฅ Dumpling
๐ฅ  Fortune Cookie
๐ฅก Takeout Box
๐ฆช Oyster
๐ฆ Soft Ice Cream
๐ง Shaved Ice
๐จ Ice Cream
๐ฉ Doughnut
๐ช Cookie
๐ Birthday Cake
๐ฐ Shortcake
๐ง Cupcake
๐ฅง Pie
๐ซ Chocolate Bar
๐ฌ Candy
๐ญ Lollipop
๐ฎ Custard
๐ฏ Honey Pot
๐ผ Baby Bottle
๐ฅ Glass of Milk
โ Hot Beverage
๐ซ Teapot
๐ต Teacup Without Handle
๐ถ Sake
๐พ Bottle with Popping Cork
๐ท Wine Glass
๐ธ Cocktail Glass
๐น Tropical Drink
๐บ Beer Mug
๐ป Clinking Beer Mugs
๐ฅ Clinking Glasses
๐ฅ Tumbler Glass
๐ซ Pouring Liquid
๐ฅค Cup with Straw
๐ง Bubble Tea
๐ง Beverage Box
๐ง Mate
๐ง Ice
๐ฅข Chopsticks
๐ฝ๏ธ Fork and Knife with Plate
๐ด Fork and Knife
๐ฅ Spoon
๐ซ Jar
๐ด๏ธ Person in Suit Levitating
๐ง Person Climbing
๐งโโ๏ธ Man Climbing
๐งโโ๏ธ Woman Climbing
๐คบ Person Fencing
๐ Horse Racing
โท๏ธ Skier
๐ Snowboarder
๐๏ธ Person Golfing
๐๏ธโโ๏ธ Man Golfing
๐๏ธโโ๏ธ Woman Golfing
๐ Person Surfing
๐โโ๏ธ Man Surfing
๐โโ๏ธ Woman Surfing
๐ฃโโ๏ธ Man Rowing Boat
๐ฃโโ๏ธ Woman Rowing Boat
๐ Person Swimming
๐โโ๏ธ Man Swimming
๐โโ๏ธ Woman Swimming
โน๏ธ Person Bouncing Ball
โน๏ธโโ๏ธ Man Bouncing Ball
โน๏ธโโ๏ธ Woman Bouncing Ball
๐๏ธ Person Lifting Weights
๐๏ธโโ๏ธ Man Lifting Weights
๐๏ธโโ๏ธ Woman Lifting Weights
๐ด Person Biking
๐ดโโ๏ธ Man Biking
๐ดโโ๏ธ Woman Biking
๐ต Person Mountain Biking
๐ตโโ๏ธ Man Mountain Biking
๐ตโโ๏ธ Woman Mountain Biking
๐คธ Person Cartwheeling
๐คธโโ๏ธ Man Cartwheeling
๐คธโโ๏ธ Woman Cartwheeling
๐คผ People Wrestling
๐คผโโ๏ธ Men Wrestling
๐คผโโ๏ธ Women Wrestling
๐คฝ Person Playing Water Polo
๐คฝโโ๏ธ Man Playing Water Polo
๐คฝโโ๏ธ Woman Playing Water Polo
๐คพ Person Playing Handball
๐คพโโ๏ธ Man Playing Handball
๐คพโโ๏ธ Woman Playing Handball
๐คน Person Juggling
๐คนโโ๏ธ Man Juggling
๐คนโโ๏ธ Woman Juggling
๐ง Person in Lotus Position
๐งโโ๏ธ Man in Lotus Position
๐งโโ๏ธ Woman in Lotus Position
๐ช Circus Tent
๐น Skateboard
๐ผ Roller Skate
๐ถ Canoe
๐๏ธ Reminder Ribbon
๐๏ธ Admission Tickets
๐ซ Ticket
๐๏ธ Military Medal
๐ Trophy
๐ Sports Medal
๐ฅ 1st Place Medal
๐ฅ 2nd Place Medal
๐ฅ 3rd Place Medal
โฝ Soccer Ball
โพ Baseball
๐ฅ Softball
๐ Basketball
๐ Volleyball
๐ American Football
๐ Rugby Football
๐พ Tennis
๐ฅ Flying Disc
๐ณ Bowling
๐ Cricket Game
๐ Field Hockey
๐ Ice Hockey
๐ฅ Lacrosse
๐ Ping Pong
๐ธ Badminton
๐ฅ Boxing Glove
๐ฅ Martial Arts Uniform
๐ฅ Goal Net
โณ Flag in Hole
โธ๏ธ Ice Skate
๐ฃ Fishing Pole
๐ฝ Running Shirt
๐ฟ Skis
๐ท Sled
๐ฅ Curling Stone
๐ฏ Bullseye
๐ฑ Pool 8 Ball
๐ฎ Video Game
๐ฐ Slot Machine
๐ฒ Game Die
๐งฉ Puzzle Piece
๐ชฉ Mirror Ball
โ๏ธ Chess Pawn
๐ญ Performing Arts
๐จ Artist Palette
๐งถ Yarn
๐ผ Musical Score
๐ค Microphone
๐ง Headphone
๐ท Saxophone
๐ช Accordion
๐ธ Guitar
๐น Musical Keyboard
๐บ Trumpet
๐ป Violin
๐ฅ Drum
๐ช Long Drum
๐ฌ Clapper Board
๐น Bow and Arrow
๐ฃ Person Rowing Boat
๐พ Map of Japan
๐๏ธ Snow-Capped Mountain
โฐ๏ธ Mountain
๐ Volcano
๐ป Mount Fuji
๐๏ธ Camping
๐๏ธ Beach with Umbrella
๐๏ธ Desert
๐๏ธ Desert Island
๐๏ธ National Park
๐๏ธ Stadium
๐๏ธ Classical Building
๐๏ธ Building Construction
๐ Hut
๐๏ธ Houses
๐๏ธ Derelict House
๐  House
๐ก House with Garden
๐ข Office Building
๐ฃ Japanese Post Office
๐ค Post Office
๐ฅ Hospital
๐ฆ Bank
๐จ Hotel
๐ฉ Love Hotel
๐ช Convenience Store
๐ซ School
๐ฌ Department Store
๐ญ Factory
๐ฏ Japanese Castle
๐ฐ Castle
๐ Wedding
๐ผ Tokyo Tower
๐ฝ Statue of Liberty
โช Church
๐ Mosque
๐ Hindu Temple
๐ Synagogue
โฉ๏ธ Shinto Shrine
๐ Kaaba
โฒ Fountain
โบ Tent
๐ Foggy
๐ Night with Stars
๐๏ธ Cityscape
๐ Sunrise Over Mountains
๐ Sunrise
๐ Cityscape at Dusk
๐ Sunset
๐ Bridge at Night
๐  Carousel Horse
๐ Playground Slide
๐ก Ferris Wheel
๐ข Roller Coaster
๐ Locomotive
๐ Railway Car
๐ High-Speed Train
๐ Bullet Train
๐ Train
๐ Metro
๐ Light Rail
๐ Station
๐ Tram
๐ Monorail
๐ Mountain Railway
๐ Tram Car
๐ Bus
๐ Oncoming Bus
๐ Trolleybus
๐ Minibus
๐ Ambulance
๐ Fire Engine
๐ Police Car
๐ Oncoming Police Car
๐ Taxi
๐ Oncoming Taxi
๐ Automobile
๐ Oncoming Automobile
๐ Sport Utility Vehicle
๐ป Pickup Truck
๐ Delivery Truck
๐ Articulated Lorry
๐ Tractor
๐๏ธ Racing Car
๐๏ธ Motorcycle
๐ต Motor Scooter
๐บ Auto Rickshaw
๐ฒ Bicycle
๐ด Kick Scooter
๐ Bus Stop
๐ฃ๏ธ Motorway
๐ค๏ธ Railway Track
โฝ Fuel Pump
๐ Wheel
๐จ Police Car Light
๐ฅ Horizontal Traffic Light
๐ฆ Vertical Traffic Light
๐ง Construction
โ Anchor
๐ Ring Buoy
โต Sailboat
๐ค Speedboat
๐ณ๏ธ Passenger Ship
โด๏ธ Ferry
๐ฅ๏ธ Motor Boat
๐ข Ship
โ๏ธ Airplane
๐ฉ๏ธ Small Airplane
๐ซ Airplane Departure
๐ฌ Airplane Arrival
๐ช Parachute
๐บ Seat
๐ Helicopter
๐ Suspension Railway
๐  Mountain Cableway
๐ก Aerial Tramway
๐ฐ๏ธ Satellite
๐ Rocket
๐ธ Flying Saucer
๐ช Ringed Planet
๐  Shooting Star
๐ Milky Way
๐ Fireworks
๐ Sparkler
๐ Moon Viewing Ceremony
๐ Passport Control
๐ Customs
๐ Baggage Claim
๐ Left Luggage
๐ Love Letter
๐ณ๏ธ Hole
๐ฃ Bomb
๐ Person Taking Bath
๐ Person in Bed
๐ช Kitchen Knife
๐บ Amphora
๐บ๏ธ World Map
๐งญ Compass
๐งฑ Brick
๐ฆฝ Manual Wheelchair
๐ฆผ Motorized Wheelchair
๐ข๏ธ Oil Drum
๐๏ธ Bellhop Bell
๐งณ Luggage
โ Hourglass Done
โณ Hourglass Not Done
โ Watch
โฐ Alarm Clock
โฑ๏ธ Stopwatch
โฒ๏ธ Timer Clock
๐ฐ๏ธ Mantelpiece Clock
๐ก๏ธ Thermometer
โฑ๏ธ Umbrella on Ground
๐งจ Firecracker
๐ Balloon
๐ Party Popper
๐ Confetti Ball
๐ Japanese Dolls
๐ Carp Streamer
๐ Wind Chime
๐งง Red Envelope
๐ Ribbon
๐ Wrapped Gift
๐คฟ Diving Mask
๐ช Yo-Yo
๐ช Kite
๐ฎ Crystal Ball
๐ช Magic Wand
๐งฟ Nazar Amulet
๐ชฌ Hamsa
๐น๏ธ Joystick
๐งธ Teddy Bear
๐ช Piรฑata
๐ช Nesting Dolls
๐ผ๏ธ Framed Picture
๐งต Thread
๐ชก Sewing Needle
๐งถ Yarn
๐ชข Knot
๐๏ธ Shopping Bags
๐ฟ Prayer Beads
๐ Gem Stone
๐๏ธ Studio Microphone
๐๏ธ Level Slider
๐๏ธ Control Knobs
๐ป Radio
๐ช Banjo
๐ฑ Mobile Phone
๐ฒ Mobile Phone with Arrow
โ๏ธ Telephone
๐ Telephone Receiver
๐ Pager
๐  Fax Machine
๐ Battery
๐ Electric Plug
๐ป Laptop
๐ฅ๏ธ Desktop Computer
๐จ๏ธ Printer
โจ๏ธ Keyboard
๐ฑ๏ธ Computer Mouse
๐ฒ๏ธ Trackball
๐ฝ Computer Disk
๐พ Floppy Disk
๐ฟ Optical Disk
๐ DVD
๐งฎ Abacus
๐ฅ Movie Camera
๐๏ธ Film Frames
๐ฝ๏ธ Film Projector
๐บ Television
๐ท Camera
๐ธ Camera with Flash
๐น Video Camera
๐ผ Videocassette
๐ Magnifying Glass Tilted Left
๐ Magnifying Glass Tilted Right
๐ฏ๏ธ Candle
๐ก Light Bulb
๐ฆ Flashlight
๐ฎ Red Paper Lantern
๐ช Diya Lamp
๐ Notebook with Decorative Cover
๐ Closed Book
๐ Open Book
๐ Green Book
๐ Blue Book
๐ Orange Book
๐ Books
๐ Notebook
๐ Ledger
๐ Page with Curl
๐ Scroll
๐ Page Facing Up
๐ฐ Newspaper
๐๏ธ Rolled-Up Newspaper
๐ Bookmark Tabs
๐ Bookmark
๐ท๏ธ Label
๐ฐ Money Bag
๐ช Coin
๐ด Yen Banknote
๐ต Dollar Banknote
๐ถ Euro Banknote
๐ท Pound Banknote
๐ธ Money with Wings
๐ณ Credit Card
๐งพ Receipt
โ๏ธ Envelope
๐ง E-Mail
๐จ Incoming Envelope
๐ฉ Envelope with Arrow
๐ค Outbox Tray
๐ฅ Inbox Tray
๐ฆ Package
๐ซ Closed Mailbox with Raised Flag
๐ช Closed Mailbox with Lowered Flag
๐ฌ Open Mailbox with Raised Flag
๐ญ Open Mailbox with Lowered Flag
๐ฎ Postbox
๐ณ๏ธ Ballot Box with Ballot
โ๏ธ Pencil
โ๏ธ Black Nib
๐๏ธ Fountain Pen
๐๏ธ Pen
๐๏ธ Paintbrush
๐๏ธ Crayon
๐ Memo
๐ File Folder
๐ Open File Folder
๐๏ธ Card Index Dividers
๐ Calendar
๐ Tear-Off Calendar
๐๏ธ Spiral Notepad
๐๏ธ Spiral Calendar
๐ Card Index
๐ Chart Increasing
๐ Chart Decreasing
๐ Bar Chart
๐ Clipboard
๐ Pushpin
๐ Round Pushpin
๐ Paperclip
๐๏ธ Linked Paperclips
๐ Straight Ruler
๐ Triangular Ruler
โ๏ธ Scissors
๐๏ธ Card File Box
๐๏ธ File Cabinet
๐๏ธ Wastebasket
๐ Locked
๐ Unlocked
๐ Locked with Pen
๐ Locked with Key
๐ Key
๐๏ธ Old Key
๐จ Hammer
๐ช Axe
โ๏ธ Pick
โ๏ธ Hammer and Pick
๐ ๏ธ Hammer and Wrench
๐ก๏ธ Dagger
โ๏ธ Crossed Swords
๐ซ Water Pistol
๐ช Boomerang
๐ก๏ธ Shield
๐ช Carpentry Saw
๐ง Wrench
๐ช Screwdriver
๐ฉ Nut and Bolt
โ๏ธ Gear
๐๏ธ Clamp
โ๏ธ Balance Scale
๐ฆฏ White Cane
๐ Link
โ๏ธ Chains
๐ช Hook
๐งฐ Toolbox
๐งฒ Magnet
๐ช Ladder
โ๏ธ Alembic
๐งช Test Tube
๐งซ Petri Dish
๐งฌ DNA
๐ฌ Microscope
๐ญ Telescope
๐ก Satellite Antenna
๐ Syringe
๐ฉธ Drop of Blood
๐ Pill
๐ฉน Adhesive Bandage
๐ฉผ Crutch
๐ฉบ Stethoscope
๐ช Door
๐ช Mirror
๐ช Window
๐๏ธ Bed
๐๏ธ Couch and Lamp
๐ช Chair
๐ฝ Toilet
๐ช  Plunger
๐ฟ Shower
๐ Bathtub
๐ชค Mouse Trap
๐ช Razor
๐งด Lotion Bottle
๐งท Safety Pin
๐งน Broom
๐งบ Basket
๐งป Roll of Paper
๐ชฃ Bucket
๐งผ Soap
๐ชฅ Toothbrush
๐งฝ Sponge
๐งฏ Fire Extinguisher
๐ Shopping Cart
๐ฌ Cigarette
โฐ๏ธ Coffin
๐ชฆ Headstone
โฑ๏ธ Funeral Urn
๐ฟ Moai
๐ชง Placard
๐ชช Identification Card
๐ฐ Potable Water
๐ Heart with Arrow
๐ Heart with Ribbon
๐ Sparkling Heart
๐ Growing Heart
๐ Beating Heart
๐ Revolving Hearts
๐ Two Hearts
๐ Heart Decoration
โฃ๏ธ Heart Exclamation
๐ Broken Heart
โค๏ธโ๐ฅ Heart on Fire
โค๏ธโ๐ฉน Mending Heart
โค๏ธ Red Heart
๐งก Orange Heart
๐ Yellow Heart
๐ Green Heart
๐ Blue Heart
๐ Purple Heart
๐ค Brown Heart
๐ค Black Heart
๐ค White Heart
๐ฏ Hundred Points
๐ข Anger Symbol
๐ฌ Speech Balloon
๐๏ธโ๐จ๏ธ Eye in Speech Bubble
๐จ๏ธ Left Speech Bubble
๐ฏ๏ธ Right Anger Bubble
๐ญ Thought Balloon
๐ค Zzz
๐ฎ White Flower
โจ๏ธ Hot Springs
๐ Barber Pole
๐ Stop Sign
๐ Twelve OโClock
๐ง Twelve-Thirty
๐ One OโClock
๐ One-Thirty
๐ Two OโClock
๐ Two-Thirty
๐ Three OโClock
๐ Three-Thirty
๐ Four OโClock
๐ Four-Thirty
๐ Five OโClock
๐  Five-Thirty
๐ Six OโClock
๐ก Six-Thirty
๐ Seven OโClock
๐ข Seven-Thirty
๐ Eight OโClock
๐ฃ Eight-Thirty
๐ Nine OโClock
๐ค Nine-Thirty
๐ Ten OโClock
๐ฅ Ten-Thirty
๐ Eleven OโClock
๐ฆ Eleven-Thirty
๐ Cyclone
โ ๏ธ Spade Suit
โฅ๏ธ Heart Suit
โฆ๏ธ Diamond Suit
โฃ๏ธ Club Suit
๐ Joker
๐ Mahjong Red Dragon
๐ด Flower Playing Cards
๐ Muted Speaker
๐ Speaker Low Volume
๐ Speaker Medium Volume
๐ Speaker High Volume
๐ข Loudspeaker
๐ฃ Megaphone
๐ฏ Postal Horn
๐ Bell
๐ Bell with Slash
๐ต Musical Note
๐ถ Musical Notes
๐น Chart Increasing with Yen
๐ Elevator
๐ง ATM Sign
๐ฎ Litter in Bin Sign
โฟ Wheelchair Symbol
๐น Menโs Room
๐บ Womenโs Room
๐ป Restroom
๐ผ Baby Symbol
๐พ Water Closet
โ ๏ธ Warning
๐ธ Children Crossing
โ No Entry
๐ซ Prohibited
๐ณ No Bicycles
๐ญ No Smoking
๐ฏ No Littering
๐ฑ Non-Potable Water
๐ท No Pedestrians
๐ต No Mobile Phones
๐ No One Under Eighteen
โข๏ธ Radioactive
โฃ๏ธ Biohazard
โฌ๏ธ Up Arrow
โ๏ธ Up-Right Arrow
โก๏ธ Right Arrow
โ๏ธ Down-Right Arrow
โฌ๏ธ Down Arrow
โ๏ธ Down-Left Arrow
โฌ๏ธ Left Arrow
โ๏ธ Up-Left Arrow
โ๏ธ Up-Down Arrow
โ๏ธ Left-Right Arrow
โฉ๏ธ Right Arrow Curving Left
โช๏ธ Left Arrow Curving Right
โคด๏ธ Right Arrow Curving Up
โคต๏ธ Right Arrow Curving Down
๐ Clockwise Vertical Arrows
๐ Counterclockwise Arrows Button
๐ Back Arrow
๐ End Arrow
๐ On! Arrow
๐ Soon Arrow
๐ Top Arrow
๐ Place of Worship
โ๏ธ Atom Symbol
๐๏ธ Om
โก๏ธ Star of David
โธ๏ธ Wheel of Dharma
โฏ๏ธ Yin Yang
โ๏ธ Latin Cross
โฆ๏ธ Orthodox Cross
โช๏ธ Star and Crescent
โฎ๏ธ Peace Symbol
๐ Menorah
๐ฏ Dotted Six-Pointed Star
โ Aries
โ Taurus
โ Gemini
โ Cancer
โ Leo
โ Virgo
โ Libra
โ Scorpio
โ Sagittarius
โ Capricorn
โ Aquarius
โ Pisces
โ Ophiuchus
๐ Shuffle Tracks Button
๐ Repeat Button
๐ Repeat Single Button
โถ๏ธ Play Button
โฉ Fast-Forward Button
โญ๏ธ Next Track Button
โฏ๏ธ Play or Pause Button
โ๏ธ Reverse Button
โช Fast Reverse Button
โฎ๏ธ Last Track Button
๐ผ Upwards Button
โซ Fast Up Button
๐ฝ Downwards Button
โฌ Fast Down Button
โธ๏ธ Pause Button
โน๏ธ Stop Button
โบ๏ธ Record Button
โ๏ธ Eject Button
๐ฆ Cinema
๐ Dim Button
๐ Bright Button
๐ถ Antenna Bars
๐ณ Vibration Mode
๐ด Mobile Phone Off
โ๏ธ Female Sign
โ๏ธ Male Sign
โ๏ธ Multiply
โ Plus
โ Minus
โ Divide
๐ฐ Heavy Equals Sign
โพ๏ธ Infinity
โผ๏ธ Double Exclamation Mark
โ๏ธ Exclamation Question Mark
โ Red Question Mark
โ White Question Mark
โ White Exclamation Mark
โ Red Exclamation Mark
ใฐ๏ธ Wavy Dash
๐ฑ Currency Exchange
๐ฒ Heavy Dollar Sign
โ๏ธ Medical Symbol
โป๏ธ Recycling Symbol
โ๏ธ Fleur-de-lis
๐ฑ Trident Emblem
๐ Name Badge
๐ฐ Japanese Symbol for Beginner
โญ Hollow Red Circle
โ Check Mark Button
โ๏ธ Check Box with Check
โ๏ธ Check Mark
โ Cross Mark
โ Cross Mark Button
โฐ Curly Loop
โฟ Double Curly Loop
ใฝ๏ธ Part Alternation Mark
โณ๏ธ Eight-Spoked Asterisk
โด๏ธ Eight-Pointed Star
โ๏ธ Sparkle
ยฉ๏ธ Copyright
ยฎ๏ธ Registered
โข๏ธ Trade Mark
#๏ธโฃ Keycap Number Sign
*๏ธโฃ Keycap Asterisk
0๏ธโฃ Keycap Digit Zero
1๏ธโฃ Keycap Digit One
2๏ธโฃ Keycap Digit Two
3๏ธโฃ Keycap Digit Three
4๏ธโฃ Keycap Digit Four
5๏ธโฃ Keycap Digit Five
6๏ธโฃ Keycap Digit Six
7๏ธโฃ Keycap Digit Seven
8๏ธโฃ Keycap Digit Eight
9๏ธโฃ Keycap Digit Nine
๐ Keycap: 10
๐  Input Latin Uppercase
๐ก Input Latin Lowercase
๐ข Input Numbers
๐ฃ Input Symbols
๐ค Input Latin Letters
๐ฐ๏ธ A Button (Blood Type)
๐ AB Button (Blood Type)
๐ฑ๏ธ B Button (Blood Type)
๐ CL Button
๐ Cool Button
๐ Free Button
โน๏ธ Information
๐ ID Button
โ๏ธ Circled M
๐ New Button
๐ NG Button
๐พ๏ธ O Button (Blood Type)
๐ OK Button
๐ฟ๏ธ P Button
๐ SOS Button
๐ Up! Button
๐ Vs Button
๐ Japanese โHereโ Button
๐๏ธ Japanese โService Chargeโ Button
๐ท๏ธ Japanese โMonthly Amountโ Button
๐ถ Japanese โNot Free of Chargeโ Button
๐ฏ Japanese โReservedโ Button
๐ Japanese โBargainโ Button
๐น Japanese โDiscountโ Button
๐ Japanese โFree of Chargeโ Button
๐ฒ Japanese โProhibitedโ Button
๐ Japanese โAcceptableโ Button
๐ธ Japanese โApplicationโ Button
๐ด Japanese โPassing Gradeโ Button
๐ณ Japanese โVacancyโ Button
ใ๏ธ Japanese โCongratulationsโ Button
ใ๏ธ Japanese โSecretโ Button
๐บ Japanese โOpen for Businessโ Button
๐ต Japanese โNo Vacancyโ Button
๐ด Red Circle
๐  Orange Circle
๐ก Yellow Circle
๐ข Green Circle
๐ต Blue Circle
๐ฃ Purple Circle
๐ค Brown Circle
โซ Black Circle
โช White Circle
๐ฅ Red Square
๐ง Orange Square
๐จ Yellow Square
๐ฉ Green Square
๐ฆ Blue Square
๐ช Purple Square
๐ซ Brown Square
โฌ Black Large Square
โฌ White Large Square
โผ๏ธ Black Medium Square
โป๏ธ White Medium Square
โพ Black Medium-Small Square
โฝ White Medium-Small Square
โช๏ธ Black Small Square
โซ๏ธ White Small Square
๐ถ Large Orange Diamond
๐ท Large Blue Diamond
๐ธ Small Orange Diamond
๐น Small Blue Diamond
๐บ Red Triangle Pointed Up
๐ป Red Triangle Pointed Down
๐  Diamond with a Dot
๐ Radio Button
๐ณ White Square Button
๐ฒ Black Square Button
๐ Chequered Flag
๐ฉ Triangular Flag
๐ Crossed Flags
๐ด Black Flag
๐ณ๏ธ White Flag
๐ณ๏ธโ๐ Rainbow Flag
๐ณ๏ธโโง๏ธ Transgender Flag
๐ดโโ ๏ธ Pirate Flag
๐ฆ๐จ Flag: Ascension Island
๐ฆ๐ฉ Flag: Andorra
๐ฆ๐ช Flag: United Arab Emirates
๐ฆ๐ซ Flag: Afghanistan
๐ฆ๐ฌ Flag: Antigua & Barbuda
๐ฆ๐ฎ Flag: Anguilla
๐ฆ๐ฑ Flag: Albania
๐ฆ๐ฒ Flag: Armenia
๐ฆ๐ด Flag: Angola
๐ฆ๐ถ Flag: Antarctica
๐ฆ๐ท Flag: Argentina
๐ฆ๐ธ Flag: American Samoa
๐ฆ๐น Flag: Austria
๐ฆ๐บ Flag: Australia
๐ฆ๐ผ Flag: Aruba
๐ฆ๐ฝ Flag: รland Islands
๐ฆ๐ฟ Flag: Azerbaijan
๐ง๐ฆ Flag: Bosnia & Herzegovina
๐ง๐ง Flag: Barbados
๐ง๐ฉ Flag: Bangladesh
๐ง๐ช Flag: Belgium
๐ง๐ซ Flag: Burkina Faso
๐ง๐ฌ Flag: Bulgaria
๐ง๐ญ Flag: Bahrain
๐ง๐ฎ Flag: Burundi
๐ง๐ฏ Flag: Benin
๐ง๐ฑ Flag: St. Barthรฉlemy
๐ง๐ฒ Flag: Bermuda
๐ง๐ณ Flag: Brunei
๐ง๐ด Flag: Bolivia
๐ง๐ถ Flag: Caribbean Netherlands
๐ง๐ท Flag: Brazil
๐ง๐ธ Flag: Bahamas
๐ง๐น Flag: Bhutan
๐ง๐ป Flag: Bouvet Island
๐ง๐ผ Flag: Botswana
๐ง๐พ Flag: Belarus
๐ง๐ฟ Flag: Belize
๐จ๐ฆ Flag: Canada
๐จ๐จ Flag: Cocos (Keeling) Islands
๐จ๐ฉ Flag: Congo - Kinshasa
๐จ๐ซ Flag: Central African Republic
๐จ๐ฌ Flag: Congo - Brazzaville
๐จ๐ญ Flag: Switzerland
๐จ๐ฎ Flag: Cรดte dโIvoire
๐จ๐ฐ Flag: Cook Islands
๐จ๐ฑ Flag: Chile
๐จ๐ฒ Flag: Cameroon
๐จ๐ณ Flag: China
๐จ๐ด Flag: Colombia
๐จ๐ต Flag: Clipperton Island
๐จ๐ท Flag: Costa Rica
๐จ๐บ Flag: Cuba
๐จ๐ป Flag: Cape Verde
๐จ๐ผ Flag: Curaรงao
๐จ๐ฝ Flag: Christmas Island
๐จ๐พ Flag: Cyprus
๐จ๐ฟ Flag: Czechia
๐ฉ๐ช Flag: Germany
๐ฉ๐ฌ Flag: Diego Garcia
๐ฉ๐ฏ Flag: Djibouti
๐ฉ๐ฐ Flag: Denmark
๐ฉ๐ฒ Flag: Dominica
๐ฉ๐ด Flag: Dominican Republic
๐ฉ๐ฟ Flag: Algeria
๐ช๐ฆ Flag: Ceuta & Melilla
๐ช๐จ Flag: Ecuador
๐ช๐ช Flag: Estonia
๐ช๐ฌ Flag: Egypt
๐ช๐ญ Flag: Western Sahara
๐ช๐ท Flag: Eritrea
๐ช๐ธ Flag: Spain
๐ช๐น Flag: Ethiopia
๐ช๐บ Flag: European Union
๐ซ๐ฎ Flag: Finland
๐ซ๐ฏ Flag: Fiji
๐ซ๐ฐ Flag: Falkland Islands
๐ซ๐ฒ Flag: Micronesia
๐ซ๐ด Flag: Faroe Islands
๐ซ๐ท Flag: France
๐ฌ๐ฆ Flag: Gabon
๐ฌ๐ง Flag: United Kingdom
๐ฌ๐ฉ Flag: Grenada
๐ฌ๐ช Flag: Georgia
๐ฌ๐ซ Flag: French Guiana
๐ฌ๐ฌ Flag: Guernsey
๐ฌ๐ญ Flag: Ghana
๐ฌ๐ฎ Flag: Gibraltar
๐ฌ๐ฑ Flag: Greenland
๐ฌ๐ฒ Flag: Gambia
๐ฌ๐ณ Flag: Guinea
๐ฌ๐ต Flag: Guadeloupe
๐ฌ๐ถ Flag: Equatorial Guinea
๐ฌ๐ท Flag: Greece
๐ฌ๐ธ Flag: South Georgia & South Sandwich Islands
๐ฌ๐น Flag: Guatemala
๐ฌ๐บ Flag: Guam
๐ฌ๐ผ Flag: Guinea-Bissau
๐ฌ๐พ Flag: Guyana
๐ญ๐ฐ Flag: Hong Kong SAR China
๐ญ๐ฒ Flag: Heard & McDonald Islands
๐ญ๐ณ Flag: Honduras
๐ญ๐ท Flag: Croatia
๐ญ๐น Flag: Haiti
๐ญ๐บ Flag: Hungary
๐ฎ๐จ Flag: Canary Islands
๐ฎ๐ฉ Flag: Indonesia
๐ฎ๐ช Flag: Ireland
๐ฎ๐ฑ Flag: Israel
๐ฎ๐ฒ Flag: Isle of Man
๐ฎ๐ณ Flag: India
๐ฎ๐ด Flag: British Indian Ocean Territory
๐ฎ๐ถ Flag: Iraq
๐ฎ๐ท Flag: Iran
๐ฎ๐ธ Flag: Iceland
๐ฎ๐น Flag: Italy
๐ฏ๐ช Flag: Jersey
๐ฏ๐ฒ Flag: Jamaica
๐ฏ๐ด Flag: Jordan
๐ฏ๐ต Flag: Japan
๐ฐ๐ช Flag: Kenya
๐ฐ๐ฌ Flag: Kyrgyzstan
๐ฐ๐ญ Flag: Cambodia
๐ฐ๐ฎ Flag: Kiribati
๐ฐ๐ฒ Flag: Comoros
๐ฐ๐ณ Flag: St. Kitts & Nevis
๐ฐ๐ต Flag: North Korea
๐ฐ๐ท Flag: South Korea
๐ฐ๐ผ Flag: Kuwait
๐ฐ๐พ Flag: Cayman Islands
๐ฐ๐ฟ Flag: Kazakhstan
๐ฑ๐ฆ Flag: Laos
๐ฑ๐ง Flag: Lebanon
๐ฑ๐จ Flag: St. Lucia
๐ฑ๐ฎ Flag: Liechtenstein
๐ฑ๐ฐ Flag: Sri Lanka
๐ฑ๐ท Flag: Liberia
๐ฑ๐ธ Flag: Lesotho
๐ฑ๐น Flag: Lithuania
๐ฑ๐บ Flag: Luxembourg
๐ฑ๐ป Flag: Latvia
๐ฑ๐พ Flag: Libya
๐ฒ๐ฆ Flag: Morocco
๐ฒ๐จ Flag: Monaco
๐ฒ๐ฉ Flag: Moldova
๐ฒ๐ช Flag: Montenegro
๐ฒ๐ซ Flag: St. Martin
๐ฒ๐ฌ Flag: Madagascar
๐ฒ๐ญ Flag: Marshall Islands
๐ฒ๐ฐ Flag: North Macedonia
๐ฒ๐ฑ Flag: Mali
๐ฒ๐ฒ Flag: Myanmar (Burma)
๐ฒ๐ณ Flag: Mongolia
๐ฒ๐ด Flag: Macao Sar China
๐ฒ๐ต Flag: Northern Mariana Islands
๐ฒ๐ถ Flag: Martinique
๐ฒ๐ท Flag: Mauritania
๐ฒ๐ธ Flag: Montserrat
๐ฒ๐น Flag: Malta
๐ฒ๐บ Flag: Mauritius
๐ฒ๐ป Flag: Maldives
๐ฒ๐ผ Flag: Malawi
๐ฒ๐ฝ Flag: Mexico
๐ฒ๐พ Flag: Malaysia
๐ฒ๐ฟ Flag: Mozambique
๐ณ๐ฆ Flag: Namibia
๐ณ๐จ Flag: New Caledonia
๐ณ๐ช Flag: Niger
๐ณ๐ซ Flag: Norfolk Island
๐ณ๐ฌ Flag: Nigeria
๐ณ๐ฎ Flag: Nicaragua
๐ณ๐ฑ Flag: Netherlands
๐ณ๐ด Flag: Norway
๐ณ๐ต Flag: Nepal
๐ณ๐ท Flag: Nauru
๐ณ๐บ Flag: Niue
๐ณ๐ฟ Flag: New Zealand
๐ด๐ฒ Flag: Oman
๐ต๐ฆ Flag: Panama
๐ต๐ช Flag: Peru
๐ต๐ซ Flag: French Polynesia
๐ต๐ฌ Flag: Papua New Guinea
๐ต๐ญ Flag: Philippines
๐ต๐ฐ Flag: Pakistan
๐ต๐ฑ Flag: Poland
๐ต๐ฒ Flag: St. Pierre & Miquelon
๐ต๐ณ Flag: Pitcairn Islands
๐ต๐ท Flag: Puerto Rico
๐ต๐ธ Flag: Palestinian Territories
๐ต๐น Flag: Portugal
๐ต๐ผ Flag: Palau
๐ต๐พ Flag: Paraguay
๐ถ๐ฆ Flag: Qatar
๐ท๐ช Flag: Rรฉunion
๐ท๐ด Flag: Romania
๐ท๐ธ Flag: Serbia
๐ท๐บ Flag: Russia
๐ท๐ผ Flag: Rwanda
๐ธ๐ฆ Flag: Saudi Arabia
๐ธ๐ง Flag: Solomon Islands
๐ธ๐จ Flag: Seychelles
๐ธ๐ฉ Flag: Sudan
๐ธ๐ช Flag: Sweden
๐ธ๐ฌ Flag: Singapore
๐ธ๐ญ Flag: St. Helena
๐ธ๐ฎ Flag: Slovenia
๐ธ๐ฏ Flag: Svalbard & Jan Mayen
๐ธ๐ฐ Flag: Slovakia
๐ธ๐ฑ Flag: Sierra Leone
๐ธ๐ฒ Flag: San Marino
๐ธ๐ณ Flag: Senegal
๐ธ๐ด Flag: Somalia
๐ธ๐ท Flag: Suriname
๐ธ๐ธ Flag: South Sudan
๐ธ๐น Flag: Sรฃo Tomรฉ & Prรญncipe
๐ธ๐ป Flag: El Salvador
๐ธ๐ฝ Flag: Sint Maarten
๐ธ๐พ Flag: Syria
๐ธ๐ฟ Flag: Eswatini
๐น๐ฆ Flag: Tristan Da Cunha
๐น๐จ Flag: Turks & Caicos Islands
๐น๐ฉ Flag: Chad
๐น๐ซ Flag: French Southern Territories
๐น๐ฌ Flag: Togo
๐น๐ญ Flag: Thailand
๐น๐ฏ Flag: Tajikistan
๐น๐ฐ Flag: Tokelau
๐น๐ฑ Flag: Timor-Leste
๐น๐ฒ Flag: Turkmenistan
๐น๐ณ Flag: Tunisia
๐น๐ด Flag: Tonga
๐น๐ท Flag: Turkey
๐น๐น Flag: Trinidad & Tobago
๐น๐ป Flag: Tuvalu
๐น๐ผ Flag: Taiwan
๐น๐ฟ Flag: Tanzania
๐บ๐ฆ Flag: Ukraine
๐บ๐ฌ Flag: Uganda
๐บ๐ฒ Flag: U.S. Outlying Islands
๐บ๐ณ Flag: United Nations
๐บ๐ธ Flag: United States
๐บ๐พ Flag: Uruguay
๐บ๐ฟ Flag: Uzbekistan
๐ป๐ฆ Flag: Vatican City
๐ป๐จ Flag: St. Vincent & Grenadines
๐ป๐ช Flag: Venezuela
๐ป๐ฌ Flag: British Virgin Islands
๐ป๐ฎ Flag: U.S. Virgin Islands
๐ป๐ณ Flag: Vietnam
๐ป๐บ Flag: Vanuatu
๐ผ๐ซ Flag: Wallis & Futuna
๐ผ๐ธ Flag: Samoa
๐ฝ๐ฐ Flag: Kosovo
๐พ๐ช Flag: Yemen
๐พ๐น Flag: Mayotte
๐ฟ๐ฆ Flag: South Africa
๐ฟ๐ฒ Flag: Zambia
๐ฟ๐ผ Flag: Zimbabwe
๐ด๓ ง๓ ข๓ ฅ๓ ฎ๓ ง๓ ฟ Flag: England
๐ด๓ ง๓ ข๓ ณ๓ ฃ๓ ด๓ ฟ Flag: Scotland
๐ด๓ ง๓ ข๓ ท๓ ฌ๓ ณ๓ ฟ Flag: Wales
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
    
    static let people = ["๐", "๐", "๐", "๐", "๐", "๐", "๐คฃ", "๐", "๐", "๐", "๐ซ ", "๐", "๐", "๐", "๐ฅฐ", "๐", "๐คฉ", "๐", "๐", "โบ๏ธ", "๐", "๐", "๐ฅฒ", "๐", "๐", "๐", "๐คช", "๐", "๐ค", "๐ค", "๐คญ", "๐ซข", "๐ซฃ", "๐คซ", "๐ค", "๐ซก", "๐ค", "๐คจ", "๐", "๐", "๐ถ", "๐ซฅ", "๐ถโ๐ซ๏ธ", "๐", "๐", "๐", "๐ฌ", "๐ฎโ๐จ", "๐คฅ", "๐", "๐", "๐ช", "๐คค", "๐ด", "๐ท", "๐ค", "๐ค", "๐คข", "๐คฎ", "๐คง", "๐ฅต", "๐ฅถ", "๐ฅด", "๐ต", "๐ตโ๐ซ", "๐คฏ", "๐ค ", "๐ฅณ", "๐ฅธ", "๐", "๐ค", "๐ง", "๐", "๐ซค", "๐", "๐", "โน๏ธ", "๐ฎ", "๐ฏ", "๐ฒ", "๐ณ", "๐ฅบ", "๐ฅน", "๐ฆ", "๐ง", "๐จ", "๐ฐ", "๐ฅ", "๐ข", "๐ญ", "๐ฑ", "๐", "๐ฃ", "๐", "๐", "๐ฉ", "๐ซ", "๐ฅฑ", "๐ค", "๐ก", "๐ ", "๐คฌ", "๐", "๐ฟ", "๐", "โ ๏ธ", "๐ฉ", "๐คก", "๐น", "๐บ", "๐ป", "๐ฝ", "๐พ", "๐ค", "๐บ", "๐ธ", "๐น", "๐ป", "๐ผ", "๐ฝ", "๐", "๐ฟ", "๐พ", "๐", "๐", "๐ค", "๐๏ธ", "โ", "๐", "๐ซฑ", "๐ซฒ", "๐ซณ", "๐ซด", "๐", "๐ค", "๐ค", "โ๏ธ", "๐ค", "๐ซฐ", "๐ค", "๐ค", "๐ค", "๐", "๐", "๐", "๐", "๐", "โ๏ธ", "๐ซต", "๐", "๐", "โ", "๐", "๐ค", "๐ค", "๐", "๐", "๐ซถ", "๐", "๐คฒ", "๐ค", "๐", "โ๏ธ", "๐", "๐คณ", "๐ช", "๐ฆพ", "๐ฆฟ", "๐ฆต", "๐ฆถ", "๐", "๐ฆป", "๐", "๐ง ", "๐ซ", "๐ซ", "๐ฆท", "๐ฆด", "๐", "๐๏ธ", "๐", "๐", "๐ซฆ", "๐ถ", "๐ง", "๐ฆ", "๐ง", "๐ง", "๐ฑ", "๐จ", "๐ง", "๐จโ๐ฆฐ", "๐จโ๐ฆฑ", "๐จโ๐ฆณ", "๐จโ๐ฆฒ", "๐ฉ", "๐ฉโ๐ฆฐ", "๐งโ๐ฆฐ", "๐ฉโ๐ฆฑ", "๐งโ๐ฆฑ", "๐ฉโ๐ฆณ", "๐งโ๐ฆณ", "๐ฉโ๐ฆฒ", "๐งโ๐ฆฒ", "๐ฑโโ๏ธ", "๐ฑโโ๏ธ", "๐ง", "๐ด", "๐ต", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐คฆ", "๐คฆโโ๏ธ", "๐คฆโโ๏ธ", "๐คท", "๐คทโโ๏ธ", "๐คทโโ๏ธ", "๐งโโ๏ธ", "๐จโโ๏ธ", "๐ฉโโ๏ธ", "๐งโ๐", "๐จโ๐", "๐ฉโ๐", "๐งโ๐ซ", "๐จโ๐ซ", "๐ฉโ๐ซ", "๐งโโ๏ธ", "๐จโโ๏ธ", "๐ฉโโ๏ธ", "๐งโ๐พ", "๐จโ๐พ", "๐ฉโ๐พ", "๐งโ๐ณ", "๐จโ๐ณ", "๐ฉโ๐ณ", "๐งโ๐ง", "๐จโ๐ง", "๐ฉโ๐ง", "๐งโ๐ญ", "๐จโ๐ญ", "๐ฉโ๐ญ", "๐งโ๐ผ", "๐จโ๐ผ", "๐ฉโ๐ผ", "๐งโ๐ฌ", "๐จโ๐ฌ", "๐ฉโ๐ฌ", "๐งโ๐ป", "๐จโ๐ป", "๐ฉโ๐ป", "๐งโ๐ค", "๐จโ๐ค", "๐ฉโ๐ค", "๐งโ๐จ", "๐จโ๐จ", "๐ฉโ๐จ", "๐งโโ๏ธ", "๐จโโ๏ธ", "๐ฉโโ๏ธ", "๐งโ๐", "๐จโ๐", "๐ฉโ๐", "๐งโ๐", "๐จโ๐", "๐ฉโ๐", "๐ฎ", "๐ฎโโ๏ธ", "๐ฎโโ๏ธ", "๐ต๏ธ", "๐ต๏ธโโ๏ธ", "๐ต๏ธโโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐ฅท", "๐ท", "๐ทโโ๏ธ", "๐ทโโ๏ธ", "๐ซ", "๐คด", "๐ธ", "๐ณ", "๐ณโโ๏ธ", "๐ณโโ๏ธ", "๐ฒ", "๐ง", "๐คต", "๐คตโโ๏ธ", "๐คตโโ๏ธ", "๐ฐ", "๐ฐโโ๏ธ", "๐ฐโโ๏ธ", "๐คฐ", "๐ซ", "๐ซ", "๐คฑ", "๐ฉโ๐ผ", "๐จโ๐ผ", "๐งโ๐ผ", "๐ผ", "๐", "๐คถ", "๐งโ๐", "๐ฆธ", "๐ฆธโโ๏ธ", "๐ฆธโโ๏ธ", "๐ฆน", "๐ฆนโโ๏ธ", "๐ฆนโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐ถ", "๐ถโโ๏ธ", "๐ถโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐งโ๐ฆฏ", "๐จโ๐ฆฏ", "๐ฉโ๐ฆฏ", "๐งโ๐ฆผ", "๐จโ๐ฆผ", "๐ฉโ๐ฆผ", "๐งโ๐ฆฝ", "๐จโ๐ฆฝ", "๐ฉโ๐ฆฝ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐", "๐บ", "๐ด๏ธ", "๐ฏ", "๐ฏโโ๏ธ", "๐ฏโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ง", "๐งโ๐คโ๐ง", "๐ญ", "๐ซ", "๐ฌ", "๐", "๐ฉโโค๏ธโ๐โ๐จ", "๐จโโค๏ธโ๐โ๐จ", "๐ฉโโค๏ธโ๐โ๐ฉ", "๐", "๐ฉโโค๏ธโ๐จ", "๐จโโค๏ธโ๐จ", "๐ฉโโค๏ธโ๐ฉ", "๐ช", "๐จโ๐ฉโ๐ฆ", "๐จโ๐ฉโ๐ง", "๐จโ๐ฉโ๐งโ๐ฆ", "๐จโ๐ฉโ๐ฆโ๐ฆ", "๐จโ๐ฉโ๐งโ๐ง", "๐จโ๐จโ๐ฆ", "๐จโ๐จโ๐ง", "๐จโ๐จโ๐งโ๐ฆ", "๐จโ๐จโ๐ฆโ๐ฆ", "๐จโ๐จโ๐งโ๐ง", "๐ฉโ๐ฉโ๐ฆ", "๐ฉโ๐ฉโ๐ง", "๐ฉโ๐ฉโ๐งโ๐ฆ", "๐ฉโ๐ฉโ๐ฆโ๐ฆ", "๐ฉโ๐ฉโ๐งโ๐ง", "๐จโ๐ฆ", "๐จโ๐ฆโ๐ฆ", "๐จโ๐ง", "๐จโ๐งโ๐ฆ", "๐จโ๐งโ๐ง", "๐ฉโ๐ฆ", "๐ฉโ๐ฆโ๐ฆ", "๐ฉโ๐ง", "๐ฉโ๐งโ๐ฆ", "๐ฉโ๐งโ๐ง", "๐ฃ๏ธ", "๐ค", "๐ฅ", "๐ซ", "๐ฃ", "๐งณ", "๐", "โ๏ธ", "๐", "๐งต", "๐งถ", "๐", "๐ถ๏ธ", "๐ฅฝ", "๐ฅผ", "๐ฆบ", "๐", "๐", "๐", "๐งฃ", "๐งค", "๐งฅ", "๐งฆ", "๐", "๐", "๐ฅป", "๐ฉฑ", "๐ฉฒ", "๐ฉณ", "๐", "๐", "๐", "๐", "๐", "๐", "๐ฉด", "๐", "๐", "๐ฅพ", "๐ฅฟ", "๐ ", "๐ก", "๐ฉฐ", "๐ข", "๐", "๐", "๐ฉ", "๐", "๐งข", "๐ช", "โ๏ธ", "๐", "๐", "๐ผ", "๐ฉธ"]
    
    static let peopleDictionary = ["Woman Shrugging": "๐คทโโ๏ธ", "Woman Singer": "๐ฉโ๐ค", "Boy": "๐ฆ", "Man Feeding Baby": "๐จโ๐ผ", "Thumbs Up": "๐", "Person Raising Hand": "๐", "Pensive Face": "๐", "Man Elf": "๐งโโ๏ธ", "Person Running": "๐", "Rightwards Hand": "๐ซฑ", "Kiss": "๐", "Backhand Index Pointing Right": "๐", "Heart Hands": "๐ซถ", "Woman in Motorized Wheelchair": "๐ฉโ๐ฆผ", "Deaf Woman": "๐งโโ๏ธ", "Robot": "๐ค", "Women with Bunny Ears": "๐ฏโโ๏ธ", "Man": "๐จ", "Person Frowning": "๐", "Family: Man, Man, Boy, Boy": "๐จโ๐จโ๐ฆโ๐ฆ", "Sunglasses": "๐ถ๏ธ", "Pleading Face": "๐ฅบ", "Couple with Heart: Woman, Woman": "๐ฉโโค๏ธโ๐ฉ", "Tired Face": "๐ซ", "Detective": "๐ต๏ธ", "Person Tipping Hand": "๐", "Woman Health Worker": "๐ฉโโ๏ธ", "Persevering Face": "๐ฃ", "Kiss Mark": "๐", "Hushed Face": "๐ฏ", "Backhand Index Pointing Down": "๐", "Skull and Crossbones": "โ ๏ธ", "Nauseated Face": "๐คข", "Man Mage": "๐งโโ๏ธ", "Face with Hand Over Mouth": "๐คญ", "Face with Open Mouth": "๐ฎ", "Kiss: Woman, Woman": "๐ฉโโค๏ธโ๐โ๐ฉ", "Person: White Hair": "๐งโ๐ฆณ", "Face Screaming in Fear": "๐ฑ", "Woman Scientist": "๐ฉโ๐ฌ", "Family: Man, Woman, Girl": "๐จโ๐ฉโ๐ง", "Man Dancing": "๐บ", "Woman Walking": "๐ถโโ๏ธ", "Family: Woman, Woman, Boy, Boy": "๐ฉโ๐ฉโ๐ฆโ๐ฆ", "Family: Man, Girl, Boy": "๐จโ๐งโ๐ฆ", "Scarf": "๐งฃ", "Couple with Heart: Man, Man": "๐จโโค๏ธโ๐จ", "Partying Face": "๐ฅณ", "Woman Pilot": "๐ฉโโ๏ธ", "Princess": "๐ธ", "Woman Genie": "๐งโโ๏ธ", "Mermaid": "๐งโโ๏ธ", "Hand with Fingers Splayed": "๐๏ธ", "Luggage": "๐งณ", "Family: Woman, Woman, Girl, Boy": "๐ฉโ๐ฉโ๐งโ๐ฆ", "Downcast Face with Sweat": "๐", "Baby": "๐ถ", "Woman Superhero": "๐ฆธโโ๏ธ", "Person Facepalming": "๐คฆ", "Person Walking": "๐ถ", "Kissing Face with Smiling Eyes": "๐", "Love-You Gesture": "๐ค", "Fairy": "๐ง", "Smiling Face with Heart-Eyes": "๐", "Astonished Face": "๐ฒ", "Woman Facepalming": "๐คฆโโ๏ธ", "Family": "๐ช", "Grinning Face with Sweat": "๐", "Supervillain": "๐ฆน", "Face with Spiral Eyes": "๐ตโ๐ซ", "Man Running": "๐โโ๏ธ", "Person: Blond Hair": "๐ฑ", "Man Mechanic": "๐จโ๐ง", "Mage": "๐ง", "Person in Lotus Position": "๐ง", "Bust in Silhouette": "๐ค", "Ghost": "๐ป", "Pilot": "๐งโโ๏ธ", "Woman: Curly Hair": "๐ฉโ๐ฆฑ", "Face Exhaling": "๐ฎโ๐จ", "Woman Fairy": "๐งโโ๏ธ", "Face with Thermometer": "๐ค", "Sleepy Face": "๐ช", "Goggles": "๐ฅฝ", "Billed Cap": "๐งข", "Grinning Squinting Face": "๐", "Slightly Frowning Face": "๐", "Man: White Hair": "๐จโ๐ฆณ", "Family: Man, Woman, Boy, Boy": "๐จโ๐ฉโ๐ฆโ๐ฆ", "Jack-O-Lantern": "๐", "Woman Raising Hand": "๐โโ๏ธ", "Cat with Wry Smile": "๐ผ", "Glasses": "๐", "Kiss: Man, Man": "๐จโโค๏ธโ๐โ๐จ", "Woman Mechanic": "๐ฉโ๐ง", "Ear with Hearing Aid": "๐ฆป", "Backpack": "๐", "Cold Face": "๐ฅถ", "Farmer": "๐งโ๐พ", "Face with Head-Bandage": "๐ค", "Handbag": "๐", "Vampire": "๐ง", "Crying Cat": "๐ฟ", "Gloves": "๐งค", "Relieved Face": "๐", "Man Fairy": "๐งโโ๏ธ", "Man Facepalming": "๐คฆโโ๏ธ", "Person Gesturing No": "๐", "Family: Man, Girl": "๐จโ๐ง", "Thread": "๐งต", "Man: Curly Hair": "๐จโ๐ฆฑ", "One-Piece Swimsuit": "๐ฉฑ", "People Hugging": "๐ซ", "Anguished Face": "๐ง", "Crossed Fingers": "๐ค", "Weary Cat": "๐", "Person with White Cane": "๐งโ๐ฆฏ", "Grimacing Face": "๐ฌ", "Leftwards Hand": "๐ซฒ", "Star-Struck": "๐คฉ", "Person: Red Hair": "๐งโ๐ฆฐ", "Man Guard": "๐โโ๏ธ", "Person: Beard": "๐ง", "Man Superhero": "๐ฆธโโ๏ธ", "Worried Face": "๐", "Man Detective": "๐ต๏ธโโ๏ธ", "Beaming Face with Smiling Eyes": "๐", "Man Scientist": "๐จโ๐ฌ", "Face with Peeking Eye": "๐ซฃ", "Kissing Cat": "๐ฝ", "Man Factory Worker": "๐จโ๐ญ", "Face with Rolling Eyes": "๐", "Woman Dancing": "๐", "Family: Woman, Woman, Girl": "๐ฉโ๐ฉโ๐ง", "Woman in Manual Wheelchair": "๐ฉโ๐ฆฝ", "Face with Tongue": "๐", "Woman Guard": "๐โโ๏ธ", "Womanโs Sandal": "๐ก", "Woman Cook": "๐ฉโ๐ณ", "Man Getting Massage": "๐โโ๏ธ", "Scientist": "๐งโ๐ฌ", "Guard": "๐", "Grinning Face": "๐", "Womanโs Clothes": "๐", "Crown": "๐", "Technologist": "๐งโ๐ป", "Yawning Face": "๐ฅฑ", "Jeans": "๐", "Exploding Head": "๐คฏ", "Family: Man, Man, Boy": "๐จโ๐จโ๐ฆ", "Genie": "๐ง", "Person in Suit Levitating": "๐ด๏ธ", "Person with Veil": "๐ฐ", "Woman Gesturing OK": "๐โโ๏ธ", "Woman Firefighter": "๐ฉโ๐", "Deaf Person": "๐ง", "Woman Supervillain": "๐ฆนโโ๏ธ", "Hot Face": "๐ฅต", "Police Officer": "๐ฎ", "Melting Face": "๐ซ ", "Coat": "๐งฅ", "Mechanic": "๐งโ๐ง", "Leg": "๐ฆต", "Woman: Red Hair": "๐ฉโ๐ฆฐ", "Frowning Face with Open Mouth": "๐ฆ", "Dotted Line Face": "๐ซฅ", "Flushed Face": "๐ณ", "Index Pointing at the Viewer": "๐ซต", "Man Bowing": "๐โโ๏ธ", "Deaf Man": "๐งโโ๏ธ", "Cook": "๐งโ๐ณ", "Mrs. Claus": "๐คถ", "Man Police Officer": "๐ฎโโ๏ธ", "Bikini": "๐", "Face with Steam From Nose": "๐ค", "Man Judge": "๐จโโ๏ธ", "Men with Bunny Ears": "๐ฏโโ๏ธ", "Smiling Face with Hearts": "๐ฅฐ", "Face Savoring Food": "๐", "Man in Manual Wheelchair": "๐จโ๐ฆฝ", "Zombie": "๐ง", "Tooth": "๐ฆท", "Pregnant Person": "๐ซ", "Call Me Hand": "๐ค", "Alien Monster": "๐พ", "Man Wearing Turban": "๐ณโโ๏ธ", "Womanโs Boot": "๐ข", "Loudly Crying Face": "๐ญ", "Lab Coat": "๐ฅผ", "Face with Tears of Joy": "๐", "Running Shoe": "๐", "Socks": "๐งฆ", "Family: Man, Man, Girl": "๐จโ๐จโ๐ง", "Man Technologist": "๐จโ๐ป", "Smiling Face with Open Hands": "๐ค", "Kiss: Woman, Man": "๐ฉโโค๏ธโ๐โ๐จ", "Ear": "๐", "Woman with Veil": "๐ฐโโ๏ธ", "Saluting Face": "๐ซก", "Woman Frowning": "๐โโ๏ธ", "Man in Tuxedo": "๐คตโโ๏ธ", "Alien": "๐ฝ", "Man Pouting": "๐โโ๏ธ", "Writing Hand": "โ๏ธ", "Baby Angel": "๐ผ", "Merman": "๐งโโ๏ธ", "Angry Face with Horns": "๐ฟ", "Smiling Face with Smiling Eyes": "๐", "Face with Open Eyes and Hand Over Mouth": "๐ซข", "Middle Finger": "๐", "Man Student": "๐จโ๐", "Woman with Headscarf": "๐ง", "Superhero": "๐ฆธ", "Grinning Face with Smiling Eyes": "๐", "Sleeping Face": "๐ด", "Cowboy Hat Face": "๐ค ", "Flexed Biceps": "๐ช", "Woman Zombie": "๐งโโ๏ธ", "Confused Face": "๐", "Raised Hand": "โ", "Person": "๐ง", "Person Bowing": "๐", "Woman Running": "๐โโ๏ธ", "Family: Man, Woman, Girl, Girl": "๐จโ๐ฉโ๐งโ๐ง", "Winking Face with Tongue": "๐", "Man Walking": "๐ถโโ๏ธ", "Merperson": "๐ง", "Grinning Cat": "๐บ", "Left-Facing Fist": "๐ค", "Prince": "๐คด", "Flat Shoe": "๐ฅฟ", "Woman and Man Holding Hands": "๐ซ", "Anatomical Heart": "๐ซ", "Man Shrugging": "๐คทโโ๏ธ", "Unamused Face": "๐", "Anxious Face with Sweat": "๐ฐ", "Pregnant Woman": "๐คฐ", "Brain": "๐ง ", "Woman Kneeling": "๐งโโ๏ธ", "Mouth": "๐", "Person Kneeling": "๐ง", "People Holding Hands": "๐งโ๐คโ๐ง", "Nose": "๐", "Woman Mage": "๐งโโ๏ธ", "Family: Man, Boy": "๐จโ๐ฆ", "Lying Face": "๐คฅ", "Man Pilot": "๐จโโ๏ธ", "Man Teacher": "๐จโ๐ซ", "Palm Up Hand": "๐ซด", "Woman Bowing": "๐โโ๏ธ", "Face Holding Back Tears": "๐ฅน", "Palm Down Hand": "๐ซณ", "Kissing Face with Closed Eyes": "๐", "Man Kneeling": "๐งโโ๏ธ", "Man Health Worker": "๐จโโ๏ธ", "Bone": "๐ฆด", "Nail Polish": "๐", "Older Person": "๐ง", "Man with Veil": "๐ฐโโ๏ธ", "Face Blowing a Kiss": "๐", "Santa Claus": "๐", "Dress": "๐", "Face in Clouds": "๐ถโ๐ซ๏ธ", "Man: Red Hair": "๐จโ๐ฆฐ", "Person: Bald": "๐งโ๐ฆฒ", "Clapping Hands": "๐", "Woman: Bald": "๐ฉโ๐ฆฒ", "Angry Face": "๐ ", "Family: Man, Woman, Girl, Boy": "๐จโ๐ฉโ๐งโ๐ฆ", "Person Shrugging": "๐คท", "Person Getting Haircut": "๐", "Face Without Mouth": "๐ถ", "Sneezing Face": "๐คง", "Man in Steamy Room": "๐งโโ๏ธ", "Woman Artist": "๐ฉโ๐จ", "Grinning Cat with Smiling Eyes": "๐ธ", "Drooling Face": "๐คค", "Ring": "๐", "Person in Tuxedo": "๐คต", "Man: Blond Hair": "๐ฑโโ๏ธ", "Face with Medical Mask": "๐ท", "Woman Vampire": "๐งโโ๏ธ", "Person in Manual Wheelchair": "๐งโ๐ฆฝ", "Man Standing": "๐งโโ๏ธ", "T-Shirt": "๐", "Purse": "๐", "Woman Astronaut": "๐ฉโ๐", "Health Worker": "๐งโโ๏ธ", "Crying Face": "๐ข", "Waving Hand": "๐", "Briefs": "๐ฉฒ", "Pile of Poo": "๐ฉ", "Rolling on the Floor Laughing": "๐คฃ", "Man Construction Worker": "๐ทโโ๏ธ", "Man Singer": "๐จโ๐ค", "Man Cook": "๐จโ๐ณ", "Skull": "๐", "Smiling Face with Sunglasses": "๐", "Man Zombie": "๐งโโ๏ธ", "Vulcan Salute": "๐", "Person with Crown": "๐ซ", "Neutral Face": "๐", "Face Vomiting": "๐คฎ", "Woman: White Hair": "๐ฉโ๐ฆณ", "Cat with Tears of Joy": "๐น", "Smiling Face with Horns": "๐", "Folded Hands": "๐", "Woman Police Officer": "๐ฎโโ๏ธ", "Person with Skullcap": "๐ฒ", "Woman Construction Worker": "๐ทโโ๏ธ", "Man Astronaut": "๐จโ๐", "Shushing Face": "๐คซ", "Slightly Smiling Face": "๐", "Lungs": "๐ซ", "Enraged Face": "๐ก", "Raised Back of Hand": "๐ค", "Man Supervillain": "๐ฆนโโ๏ธ", "Right-Facing Fist": "๐ค", "Umbrella": "โ๏ธ", "Man Frowning": "๐โโ๏ธ", "Student": "๐งโ๐", "Speaking Head": "๐ฃ๏ธ", "Woman Teacher": "๐ฉโ๐ซ", "Person Gesturing OK": "๐", "Selfie": "๐คณ", "Briefcase": "๐ผ", "Man Artist": "๐จโ๐จ", "Man in Motorized Wheelchair": "๐จโ๐ฆผ", "Woman: Blond Hair": "๐ฑโโ๏ธ", "Man Gesturing OK": "๐โโ๏ธ", "Pinching Hand": "๐ค", "Old Woman": "๐ต", "Family: Man, Man, Girl, Boy": "๐จโ๐จโ๐งโ๐ฆ", "Sari": "๐ฅป", "Woman in Steamy Room": "๐งโโ๏ธ", "Person: Curly Hair": "๐งโ๐ฆฑ", "Biting Lip": "๐ซฆ", "Eyes": "๐", "Woman": "๐ฉ", "Woman Wearing Turban": "๐ณโโ๏ธ", "Woman Pouting": "๐โโ๏ธ", "Index Pointing Up": "โ๏ธ", "Yarn": "๐งถ", "Ninja": "๐ฅท", "Man: Bald": "๐จโ๐ฆฒ", "Squinting Face with Tongue": "๐", "Grinning Face with Big Eyes": "๐", "Family: Man, Man, Girl, Girl": "๐จโ๐จโ๐งโ๐ง", "Busts in Silhouette": "๐ฅ", "Women Holding Hands": "๐ญ", "Man Gesturing No": "๐โโ๏ธ", "Family: Woman, Woman, Girl, Girl": "๐ฉโ๐ฉโ๐งโ๐ง", "Kissing Face": "๐", "Construction Worker": "๐ท", "Weary Face": "๐ฉ", "Family: Woman, Girl": "๐ฉโ๐ง", "Sad but Relieved Face": "๐ฅ", "Woman in Tuxedo": "๐คตโโ๏ธ", "Breast-Feeding": "๐คฑ", "Woman Tipping Hand": "๐โโ๏ธ", "Woman Feeding Baby": "๐ฉโ๐ผ", "Person Standing": "๐ง", "Nerd Face": "๐ค", "Tongue": "๐", "Kimono": "๐", "Man Getting Haircut": "๐โโ๏ธ", "Thinking Face": "๐ค", "Woman Elf": "๐งโโ๏ธ", "Person in Motorized Wheelchair": "๐งโ๐ฆผ", "Pregnant Man": "๐ซ", "Person in Steamy Room": "๐ง", "Eye": "๐๏ธ", "Smirking Face": "๐", "Person Getting Massage": "๐", "Woman Gesturing No": "๐โโ๏ธ", "Child": "๐ง", "Couple with Heart": "๐", "Clutch Bag": "๐", "Old Man": "๐ด", "Firefighter": "๐งโ๐", "Smiling Cat with Heart-Eyes": "๐ป", "Judge": "๐งโโ๏ธ", "Disappointed Face": "๐", "Sign of the Horns": "๐ค", "Woman Farmer": "๐ฉโ๐พ", "Smiling Face": "โบ๏ธ", "Girl": "๐ง", "Backhand Index Pointing Up": "๐", "Woman Judge": "๐ฉโโ๏ธ", "Woman Technologist": "๐ฉโ๐ป", "Man Tipping Hand": "๐โโ๏ธ", "Footprints": "๐ฃ", "Thong Sandal": "๐ฉด", "Man Raising Hand": "๐โโ๏ธ", "Man Vampire": "๐งโโ๏ธ", "Ogre": "๐น", "Hiking Boot": "๐ฅพ", "Family: Man, Boy, Boy": "๐จโ๐ฆโ๐ฆ", "Family: Woman, Girl, Girl": "๐ฉโ๐งโ๐ง", "Mechanical Leg": "๐ฆฟ", "Mechanical Arm": "๐ฆพ", "Foot": "๐ฆถ", "Safety Vest": "๐ฆบ", "Woman Standing": "๐งโโ๏ธ", "Woman Detective": "๐ต๏ธโโ๏ธ", "Mx Claus": "๐งโ๐", "Necktie": "๐", "Open Hands": "๐", "Drop of Blood": "๐ฉธ", "OK Hand": "๐", "People with Bunny Ears": "๐ฏ", "Ballet Shoes": "๐ฉฐ", "Shorts": "๐ฉณ", "Artist": "๐งโ๐จ", "Lipstick": "๐", "Zipper-Mouth Face": "๐ค", "Woman with White Cane": "๐ฉโ๐ฆฏ", "Money-Mouth Face": "๐ค", "Top Hat": "๐ฉ", "Oncoming Fist": "๐", "Pinched Fingers": "๐ค", "Clown Face": "๐คก", "Office Worker": "๐งโ๐ผ", "Elf": "๐ง", "Goblin": "๐บ", "Palms Up Together": "๐คฒ", "Man Office Worker": "๐จโ๐ผ", "Womanโs Hat": "๐", "Confounded Face": "๐", "Graduation Cap": "๐", "Family: Woman, Boy": "๐ฉโ๐ฆ", "Woman Office Worker": "๐ฉโ๐ผ", "Person Feeding Baby": "๐งโ๐ผ", "Men Holding Hands": "๐ฌ", "Pouting Cat": "๐พ", "Military Helmet": "๐ช", "Family: Man, Woman, Boy": "๐จโ๐ฉโ๐ฆ", "Family: Man, Girl, Girl": "๐จโ๐งโ๐ง", "Woman Student": "๐ฉโ๐", "Singer": "๐งโ๐ค", "Man with White Cane": "๐จโ๐ฆฏ", "Man Farmer": "๐จโ๐พ", "Man Genie": "๐งโโ๏ธ", "Backhand Index Pointing Left": "๐", "Face with Raised Eyebrow": "๐คจ", "Closed Umbrella": "๐", "Factory Worker": "๐งโ๐ญ", "Teacher": "๐งโ๐ซ", "Expressionless Face": "๐", "Face with Monocle": "๐ง", "Family: Woman, Boy, Boy": "๐ฉโ๐ฆโ๐ฆ", "Hand with Index Finger and Thumb Crossed": "๐ซฐ", "Raised Fist": "โ", "Manโs Shoe": "๐", "Woman Getting Haircut": "๐โโ๏ธ", "Handshake": "๐ค", "Woman Getting Massage": "๐โโ๏ธ", "Couple with Heart: Woman, Man": "๐ฉโโค๏ธโ๐จ", "Winking Face": "๐", "Smiling Face with Halo": "๐", "Frowning Face": "โน๏ธ", "Rescue Workerโs Helmet": "โ๏ธ", "Woman Factory Worker": "๐ฉโ๐ญ", "Woozy Face": "๐ฅด", "Fearful Face": "๐จ", "Smiling Face with Tear": "๐ฅฒ", "Face with Crossed-Out Eyes": "๐ต", "Face with Diagonal Mouth": "๐ซค", "Thumbs Down": "๐", "High-Heeled Shoe": "๐ ", "Person Wearing Turban": "๐ณ", "Face with Symbols on Mouth": "๐คฌ", "Troll": "๐ง", "Person Pouting": "๐", "Raising Hands": "๐", "Astronaut": "๐งโ๐", "Family: Woman, Woman, Boy": "๐ฉโ๐ฉโ๐ฆ", "Family: Woman, Girl, Boy": "๐ฉโ๐งโ๐ฆ", "Upside-Down Face": "๐", "Disguised Face": "๐ฅธ", "Man Firefighter": "๐จโ๐", "Zany Face": "๐คช", "Victory Hand": "โ๏ธ"]
    
    static let animalsNNature = ["๐", "๐", "๐", "๐ฅ", "๐ซ", "๐ฆ", "๐จ", "๐ต", "๐", "๐ฆ", "๐ฆง", "๐ถ", "๐", "๐ฆฎ", "๐โ๐ฆบ", "๐ฉ", "๐บ", "๐ฆ", "๐ฆ", "๐ฑ", "๐", "๐โโฌ", "๐ฆ", "๐ฏ", "๐", "๐", "๐ด", "๐", "๐ฆ", "๐ฆ", "๐ฆ", "๐ฆฌ", "๐ฎ", "๐", "๐", "๐", "๐ท", "๐", "๐", "๐ฝ", "๐", "๐", "๐", "๐ช", "๐ซ", "๐ฆ", "๐ฆ", "๐", "๐ฆฃ", "๐ฆ", "๐ฆ", "๐ญ", "๐", "๐", "๐น", "๐ฐ", "๐", "๐ฟ๏ธ", "๐ฆซ", "๐ฆ", "๐ฆ", "๐ป", "๐ปโโ๏ธ", "๐จ", "๐ผ", "๐ฆฅ", "๐ฆฆ", "๐ฆจ", "๐ฆ", "๐ฆก", "๐พ", "๐ฆ", "๐", "๐", "๐ฃ", "๐ค", "๐ฅ", "๐ฆ", "๐ง", "๐๏ธ", "๐ฆ", "๐ฆ", "๐ฆข", "๐ฆ", "๐ฆค", "๐ชถ", "๐ฆฉ", "๐ฆ", "๐ฆ", "๐ธ", "๐", "๐ข", "๐ฆ", "๐", "๐ฒ", "๐", "๐ฆ", "๐ฆ", "๐ณ", "๐", "๐ฌ", "๐ฆญ", "๐", "๐ ", "๐ก", "๐ฆ", "๐", "๐", "๐ชธ", "๐", "๐ฆ", "๐", "๐", "๐", "๐ชฒ", "๐", "๐ฆ", "๐ชณ", "๐ท๏ธ", "๐ธ๏ธ", "๐ฆ", "๐ฆ", "๐ชฐ", "๐ชฑ", "๐ฆ ", "๐", "๐ธ", "๐ฎ", "๐ชท", "๐ต๏ธ", "๐น", "๐ฅ", "๐บ", "๐ป", "๐ผ", "๐ท", "๐ฑ", "๐ชด", "๐ฒ", "๐ณ", "๐ด", "๐ต", "๐พ", "๐ฟ", "โ๏ธ", "๐", "๐", "๐", "๐", "๐ชน", "๐ชบ", "๐", "๐ฐ", "๐ฆ", "๐ฆ", "๐ฆ", "๐ฆ", "๐", "๐", "๐", "๐", "๐ชจ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "โ๏ธ", "๐", "๐", "โญ", "๐", "๐ ", "โ๏ธ", "โ", "โ๏ธ", "๐ค๏ธ", "๐ฅ๏ธ", "๐ฆ๏ธ", "๐ง๏ธ", "๐จ๏ธ", "๐ฉ๏ธ", "๐ช๏ธ", "๐ซ๏ธ", "๐ฌ๏ธ", "๐", "โ๏ธ", "โ", "โก", "โ๏ธ", "โ๏ธ", "โ", "โ๏ธ", "๐ฅ", "๐ง", "๐", "๐", "โจ", "๐", "๐", "๐ซง"]
    
    static let animalsNNatureDictionary = ["Four Leaf Clover": "๐", "Chicken": "๐", "Tornado": "๐ช๏ธ", "Whale": "๐", "Pig Nose": "๐ฝ", "Shamrock": "โ๏ธ", "Sheaf of Rice": "๐พ", "Lotus": "๐ชท", "Goat": "๐", "New Moon": "๐", "Mosquito": "๐ฆ", "Feather": "๐ชถ", "Beetle": "๐ชฒ", "Baby Chick": "๐ค", "T-Rex": "๐ฆ", "Rabbit": "๐", "Waxing Crescent Moon": "๐", "First Quarter Moon": "๐", "Gorilla": "๐ฆ", "Guide Dog": "๐ฆฎ", "Koala": "๐จ", "Pine Decoration": "๐", "Penguin": "๐ง", "Collision": "๐ฅ", "Wind Face": "๐ฌ๏ธ", "Potted Plant": "๐ชด", "Bison": "๐ฆฌ", "Cactus": "๐ต", "Cow Face": "๐ฎ", "Umbrella": "โ๏ธ", "Umbrella with Rain Drops": "โ", "Spider Web": "๐ธ๏ธ", "Horse Face": "๐ด", "Black Cat": "๐โโฌ", "Orangutan": "๐ฆง", "Sun Behind Large Cloud": "๐ฅ๏ธ", "Hamster": "๐น", "Fish": "๐", "Sun": "โ๏ธ", "Frog": "๐ธ", "Cherry Blossom": "๐ธ", "Water Buffalo": "๐", "Crab": "๐ฆ", "Scorpion": "๐ฆ", "Coral": "๐ชธ", "Bird": "๐ฆ", "White Flower": "๐ฎ", "Camel": "๐ช", "Cloud": "โ๏ธ", "Hatching Chick": "๐ฃ", "Mouse Face": "๐ญ", "Seal": "๐ฆญ", "Spiral Shell": "๐", "Duck": "๐ฆ", "Chipmunk": "๐ฟ๏ธ", "Turkey": "๐ฆ", "Pig Face": "๐ท", "Evergreen Tree": "๐ฒ", "Mouse": "๐", "Boar": "๐", "Water Wave": "๐", "Ox": "๐", "Crocodile": "๐", "See-No-Evil Monkey": "๐", "Swan": "๐ฆข", "Waning Gibbous Moon": "๐", "Polar Bear": "๐ปโโ๏ธ", "Tulip": "๐ท", "Maple Leaf": "๐", "Sun Behind Rain Cloud": "๐ฆ๏ธ", "Mushroom": "๐", "New Moon Face": "๐", "Octopus": "๐", "Lady Beetle": "๐", "Bear": "๐ป", "Honeybee": "๐", "Christmas Tree": "๐", "Dolphin": "๐ฌ", "Otter": "๐ฆฆ", "Globe Showing Europe-Africa": "๐", "Dog": "๐", "Dove": "๐๏ธ", "Leaf Fluttering in Wind": "๐", "Worm": "๐ชฑ", "Deer": "๐ฆ", "Bouquet": "๐", "Horse": "๐", "Cat": "๐", "Sparkles": "โจ", "Dragon Face": "๐ฒ", "Rat": "๐", "Spouting Whale": "๐ณ", "Full Moon Face": "๐", "Lobster": "๐ฆ", "Blowfish": "๐ก", "Palm Tree": "๐ด", "Fire": "๐ฅ", "Hippopotamus": "๐ฆ", "Paw Prints": "๐พ", "Droplet": "๐ง", "High Voltage": "โก", "Blossom": "๐ผ", "Deciduous Tree": "๐ณ", "Hear-No-Evil Monkey": "๐", "Dizzy": "๐ซ", "Snowman": "โ๏ธ", "Poodle": "๐ฉ", "Tiger": "๐", "Butterfly": "๐ฆ", "Giraffe": "๐ฆ", "Chestnut": "๐ฐ", "Rabbit Face": "๐ฐ", "Fog": "๐ซ๏ธ", "Tiger Face": "๐ฏ", "Kangaroo": "๐ฆ", "Nest with Eggs": "๐ชบ", "Service Dog": "๐โ๐ฆบ", "Cloud with Lightning and Rain": "โ๏ธ", "Shooting Star": "๐ ", "Ant": "๐", "Elephant": "๐", "Waning Crescent Moon": "๐", "Last Quarter Moon Face": "๐", "Rhinoceros": "๐ฆ", "Globe with Meridians": "๐", "Sunflower": "๐ป", "Flamingo": "๐ฆฉ", "Sun Behind Cloud": "โ", "Fox": "๐ฆ", "Snowman Without Snow": "โ", "Owl": "๐ฆ", "Monkey": "๐", "Dragon": "๐", "Dog Face": "๐ถ", "Speak-No-Evil Monkey": "๐", "Zebra": "๐ฆ", "Tanabata Tree": "๐", "Hedgehog": "๐ฆ", "Leopard": "๐", "Eagle": "๐ฆ", "Herb": "๐ฟ", "Squid": "๐ฆ", "Peacock": "๐ฆ", "Llama": "๐ฆ", "Tropical Fish": "๐ ", "Sloth": "๐ฆฅ", "Seedling": "๐ฑ", "Monkey Face": "๐ต", "Rainbow": "๐", "Rooster": "๐", "Crescent Moon": "๐", "Fallen Leaf": "๐", "Hibiscus": "๐บ", "Bug": "๐", "Unicorn": "๐ฆ", "Turtle": "๐ข", "Cricket": "๐ฆ", "Rock": "๐ชจ", "Cat Face": "๐ฑ", "Dashing Away": "๐จ", "Wolf": "๐บ", "Empty Nest": "๐ชน", "Snake": "๐", "Front-Facing Baby Chick": "๐ฅ", "Ram": "๐", "Cockroach": "๐ชณ", "Two-Hump Camel": "๐ซ", "Bat": "๐ฆ", "Sweat Droplets": "๐ฆ", "Fly": "๐ชฐ", "Ewe": "๐", "Lion": "๐ฆ", "Cloud with Lightning": "๐ฉ๏ธ", "Sun Behind Small Cloud": "๐ค๏ธ", "Cloud with Rain": "๐ง๏ธ", "Star": "โญ", "Wilted Flower": "๐ฅ", "Cow": "๐", "Glowing Star": "๐", "Cloud with Snow": "๐จ๏ธ", "Globe Showing Americas": "๐", "Skunk": "๐ฆจ", "Shark": "๐ฆ", "Shrimp": "๐ฆ", "Badger": "๐ฆก", "Full Moon": "๐", "Microbe": "๐ฆ ", "Mammoth": "๐ฆฃ", "Snowflake": "โ๏ธ", "Sauropod": "๐ฆ", "Bubbles": "๐ซง", "Snail": "๐", "Globe Showing Asia-Australia": "๐", "Panda": "๐ผ", "Last Quarter Moon": "๐", "Spider": "๐ท๏ธ", "Raccoon": "๐ฆ", "Sun with Face": "๐", "Waxing Gibbous Moon": "๐", "Pig": "๐", "First Quarter Moon Face": "๐", "Beaver": "๐ฆซ", "Parrot": "๐ฆ", "Comet": "โ๏ธ", "Rosette": "๐ต๏ธ", "Lizard": "๐ฆ", "Dodo": "๐ฆค", "Rose": "๐น"]
    
    static let foodNDrink = ["๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ฅญ", "๐", "๐", "๐", "๐", "๐", "๐", "๐ซ", "๐ฅ", "๐", "๐ซ", "๐ฅฅ", "๐ฅ", "๐", "๐ฅ", "๐ฅ", "๐ฝ", "๐ถ๏ธ", "๐ซ", "๐ฅ", "๐ฅฌ", "๐ฅฆ", "๐ง", "๐ง", "๐", "๐ฅ", "๐ซ", "๐ฐ", "๐", "๐ฅ", "๐ฅ", "๐ซ", "๐ฅจ", "๐ฅฏ", "๐ฅ", "๐ง", "๐ง", "๐", "๐", "๐ฅฉ", "๐ฅ", "๐", "๐", "๐", "๐ญ", "๐ฅช", "๐ฎ", "๐ฏ", "๐ซ", "๐ฅ", "๐ง", "๐ฅ", "๐ณ", "๐ฅ", "๐ฒ", "๐ซ", "๐ฅฃ", "๐ฅ", "๐ฟ", "๐ง", "๐ง", "๐ฅซ", "๐ฑ", "๐", "๐", "๐", "๐", "๐", "๐", "๐ ", "๐ข", "๐ฃ", "๐ค", "๐ฅ", "๐ฅฎ", "๐ก", "๐ฅ", "๐ฅ ", "๐ฅก", "๐ฆช", "๐ฆ", "๐ง", "๐จ", "๐ฉ", "๐ช", "๐", "๐ฐ", "๐ง", "๐ฅง", "๐ซ", "๐ฌ", "๐ญ", "๐ฎ", "๐ฏ", "๐ผ", "๐ฅ", "โ", "๐ซ", "๐ต", "๐ถ", "๐พ", "๐ท", "๐ธ", "๐น", "๐บ", "๐ป", "๐ฅ", "๐ฅ", "๐ซ", "๐ฅค", "๐ง", "๐ง", "๐ง", "๐ง", "๐ฅข", "๐ฝ๏ธ", "๐ด", "๐ฅ", "๐ซ"]
    
    static let foodNDrinkDictionary = ["Teacup Without Handle": "๐ต", "Bread": "๐", "Beans": "๐ซ", "Green Salad": "๐ฅ", "Hot Dog": "๐ญ", "Curry Rice": "๐", "Chopsticks": "๐ฅข", "Ear of Corn": "๐ฝ", "Garlic": "๐ง", "Olive": "๐ซ", "Cucumber": "๐ฅ", "Tamale": "๐ซ", "Fried Shrimp": "๐ค", "Hot Beverage": "โ", "Clinking Beer Mugs": "๐ป", "Custard": "๐ฎ", "Cooked Rice": "๐", "Sandwich": "๐ฅช", "Kiwi Fruit": "๐ฅ", "Doughnut": "๐ฉ", "Baguette Bread": "๐ฅ", "Leafy Green": "๐ฅฌ", "Carrot": "๐ฅ", "French Fries": "๐", "Bento Box": "๐ฑ", "Cherries": "๐", "Lollipop": "๐ญ", "Pot of Food": "๐ฒ", "Peach": "๐", "Chestnut": "๐ฐ", "Pie": "๐ฅง", "Bubble Tea": "๐ง", "Flatbread": "๐ซ", "Onion": "๐ง", "Lemon": "๐", "Bagel": "๐ฅฏ", "Taco": "๐ฎ", "Banana": "๐", "Pineapple": "๐", "Salt": "๐ง", "Candy": "๐ฌ", "Pretzel": "๐ฅจ", "Cookie": "๐ช", "Baby Bottle": "๐ผ", "Falafel": "๐ง", "Cheese Wedge": "๐ง", "Butter": "๐ง", "Potato": "๐ฅ", "Dango": "๐ก", "Honey Pot": "๐ฏ", "Mango": "๐ฅญ", "Watermelon": "๐", "Mushroom": "๐", "Croissant": "๐ฅ", "Ice Cream": "๐จ", "Glass of Milk": "๐ฅ", "Shallow Pan of Food": "๐ฅ", "Sake": "๐ถ", "Cocktail Glass": "๐ธ", "Tomato": "๐", "Fondue": "๐ซ", "Blueberries": "๐ซ", "Chocolate Bar": "๐ซ", "Grapes": "๐", "Shaved Ice": "๐ง", "Wine Glass": "๐ท", "Ice": "๐ง", "Waffle": "๐ง", "Pear": "๐", "Oyster": "๐ฆช", "Hamburger": "๐", "Bell Pepper": "๐ซ", "Oden": "๐ข", "Cut of Meat": "๐ฅฉ", "Green Apple": "๐", "Roasted Sweet Potato": "๐ ", "Rice Cracker": "๐", "Broccoli": "๐ฅฆ", "Teapot": "๐ซ", "Peanuts": "๐ฅ", "Tropical Drink": "๐น", "Fork and Knife with Plate": "๐ฝ๏ธ", "Rice Ball": "๐", "Soft Ice Cream": "๐ฆ", "Burrito": "๐ฏ", "Mate": "๐ง", "Jar": "๐ซ", "Clinking Glasses": "๐ฅ", "Melon": "๐", "Pancakes": "๐ฅ", "Fortune Cookie": "๐ฅ ", "Bowl with Spoon": "๐ฅฃ", "Cooking": "๐ณ", "Hot Pepper": "๐ถ๏ธ", "Cupcake": "๐ง", "Tangerine": "๐", "Moon Cake": "๐ฅฎ", "Popcorn": "๐ฟ", "Canned Food": "๐ฅซ", "Bottle with Popping Cork": "๐พ", "Beverage Box": "๐ง", "Beer Mug": "๐บ", "Steaming Bowl": "๐", "Coconut": "๐ฅฅ", "Takeout Box": "๐ฅก", "Tumbler Glass": "๐ฅ", "Cup with Straw": "๐ฅค", "Dumpling": "๐ฅ", "Spaghetti": "๐", "Sushi": "๐ฃ", "Fork and Knife": "๐ด", "Poultry Leg": "๐", "Spoon": "๐ฅ", "Fish Cake with Swirl": "๐ฅ", "Pouring Liquid": "๐ซ", "Avocado": "๐ฅ", "Shortcake": "๐ฐ", "Stuffed Flatbread": "๐ฅ", "Pizza": "๐", "Egg": "๐ฅ", "Eggplant": "๐", "Bacon": "๐ฅ", "Strawberry": "๐", "Birthday Cake": "๐", "Meat on Bone": "๐", "Red Apple": "๐"]

    
    static let activity = ["๐ด๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐คบ", "๐", "โท๏ธ", "๐", "๐๏ธ", "๐๏ธโโ๏ธ", "๐๏ธโโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "๐ฃ", "๐ฃโโ๏ธ", "๐ฃโโ๏ธ", "๐", "๐โโ๏ธ", "๐โโ๏ธ", "โน๏ธ", "โน๏ธโโ๏ธ", "โน๏ธโโ๏ธ", "๐๏ธ", "๐๏ธโโ๏ธ", "๐๏ธโโ๏ธ", "๐ด", "๐ดโโ๏ธ", "๐ดโโ๏ธ", "๐ต", "๐ตโโ๏ธ", "๐ตโโ๏ธ", "๐คธ", "๐คธโโ๏ธ", "๐คธโโ๏ธ", "๐คผ", "๐คผโโ๏ธ", "๐คผโโ๏ธ", "๐คฝ", "๐คฝโโ๏ธ", "๐คฝโโ๏ธ", "๐คพ", "๐คพโโ๏ธ", "๐คพโโ๏ธ", "๐คน", "๐คนโโ๏ธ", "๐คนโโ๏ธ", "๐ง", "๐งโโ๏ธ", "๐งโโ๏ธ", "๐ช", "๐น", "๐ผ", "๐ถ", "๐๏ธ", "๐๏ธ", "๐ซ", "๐๏ธ", "๐", "๐", "๐ฅ", "๐ฅ", "๐ฅ", "โฝ", "โพ", "๐ฅ", "๐", "๐", "๐", "๐", "๐พ", "๐ฅ", "๐ณ", "๐", "๐", "๐", "๐ฅ", "๐", "๐ธ", "๐ฅ", "๐ฅ", "๐ฅ", "โณ", "โธ๏ธ", "๐ฃ", "๐ฝ", "๐ฟ", "๐ท", "๐ฅ", "๐ฏ", "๐ฑ", "๐ฎ", "๐ฐ", "๐ฒ", "๐งฉ", "๐ชฉ", "โ๏ธ", "๐ญ", "๐จ", "๐งต", "๐งถ", "๐ผ", "๐ค", "๐ง", "๐ท", "๐ช", "๐ธ", "๐น", "๐บ", "๐ป", "๐ฅ", "๐ช", "๐ฌ", "๐น"]
    
    static let activityDictionary = ["Person Lifting Weights": "๐๏ธ", "Person in Suit Levitating": "๐ด๏ธ", "Man Golfing": "๐๏ธโโ๏ธ", "Person Surfing": "๐", "Woman Playing Handball": "๐คพโโ๏ธ", "Man Cartwheeling": "๐คธโโ๏ธ", "Ice Hockey": "๐", "Bow and Arrow": "๐น", "Musical Score": "๐ผ", "3rd Place Medal": "๐ฅ", "Badminton": "๐ธ", "Mirror Ball": "๐ชฉ", "Running Shirt": "๐ฝ", "Slot Machine": "๐ฐ", "Skier": "โท๏ธ", "1st Place Medal": "๐ฅ", "Woman Mountain Biking": "๐ตโโ๏ธ", "Woman Climbing": "๐งโโ๏ธ", "Soccer Ball": "โฝ", "Canoe": "๐ถ", "Man Biking": "๐ดโโ๏ธ", "Trophy": "๐", "Person Playing Handball": "๐คพ", "Snowboarder": "๐", "Video Game": "๐ฎ", "Man Playing Handball": "๐คพโโ๏ธ", "Thread": "๐งต", "Headphone": "๐ง", "Pool 8 Ball": "๐ฑ", "Man Playing Water Polo": "๐คฝโโ๏ธ", "Guitar": "๐ธ", "Man Bouncing Ball": "โน๏ธโโ๏ธ", "Bowling": "๐ณ", "Skis": "๐ฟ", "Yarn": "๐งถ", "American Football": "๐", "Person Bouncing Ball": "โน๏ธ", "Flying Disc": "๐ฅ", "Martial Arts Uniform": "๐ฅ", "Man Lifting Weights": "๐๏ธโโ๏ธ", "Men Wrestling": "๐คผโโ๏ธ", "Woman Rowing Boat": "๐ฃโโ๏ธ", "Microphone": "๐ค", "Fishing Pole": "๐ฃ", "Military Medal": "๐๏ธ", "Musical Keyboard": "๐น", "Person Cartwheeling": "๐คธ", "Sled": "๐ท", "Women Wrestling": "๐คผโโ๏ธ", "Violin": "๐ป", "Accordion": "๐ช", "Man Juggling": "๐คนโโ๏ธ", "Woman Juggling": "๐คนโโ๏ธ", "Roller Skate": "๐ผ", "Man Swimming": "๐โโ๏ธ", "Man Mountain Biking": "๐ตโโ๏ธ", "Ticket": "๐ซ", "Long Drum": "๐ช", "Drum": "๐ฅ", "Person Playing Water Polo": "๐คฝ", "Woman Surfing": "๐โโ๏ธ", "Field Hockey": "๐", "Tennis": "๐พ", "Ice Skate": "โธ๏ธ", "Chess Pawn": "โ๏ธ", "Woman Bouncing Ball": "โน๏ธโโ๏ธ", "Horse Racing": "๐", "Woman Golfing": "๐๏ธโโ๏ธ", "Artist Palette": "๐จ", "Bullseye": "๐ฏ", "Circus Tent": "๐ช", "Puzzle Piece": "๐งฉ", "Woman Lifting Weights": "๐๏ธโโ๏ธ", "Trumpet": "๐บ", "Goal Net": "๐ฅ", "Boxing Glove": "๐ฅ", "Basketball": "๐", "Performing Arts": "๐ญ", "Baseball": "โพ", "Person Swimming": "๐", "Cricket Game": "๐", "Reminder Ribbon": "๐๏ธ", "Skateboard": "๐น", "Volleyball": "๐", "Woman Cartwheeling": "๐คธโโ๏ธ", "Person Juggling": "๐คน", "Softball": "๐ฅ", "Admission Tickets": "๐๏ธ", "Woman Biking": "๐ดโโ๏ธ", "Man Climbing": "๐งโโ๏ธ", "Person Biking": "๐ด", "Clapper Board": "๐ฌ", "People Wrestling": "๐คผ", "Saxophone": "๐ท", "Woman Swimming": "๐โโ๏ธ", "Curling Stone": "๐ฅ", "Person Rowing Boat": "๐ฃ", "Woman in Lotus Position": "๐งโโ๏ธ", "Person Climbing": "๐ง", "Man Surfing": "๐โโ๏ธ", "2nd Place Medal": "๐ฅ", "Person Golfing": "๐๏ธ", "Game Die": "๐ฒ", "Woman Playing Water Polo": "๐คฝโโ๏ธ", "Person in Lotus Position": "๐ง", "Rugby Football": "๐", "Flag in Hole": "โณ", "Ping Pong": "๐", "Person Mountain Biking": "๐ต", "Man Rowing Boat": "๐ฃโโ๏ธ", "Man in Lotus Position": "๐งโโ๏ธ", "Sports Medal": "๐", "Person Fencing": "๐คบ", "Lacrosse": "๐ฅ"]
    
    static let travelNPlaces = ["๐ฃ", "๐พ", "๐๏ธ", "โฐ๏ธ", "๐", "๐ป", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐", "๐๏ธ", "๐๏ธ", "๐ ", "๐ก", "๐ข", "๐ฃ", "๐ค", "๐ฅ", "๐ฆ", "๐จ", "๐ฉ", "๐ช", "๐ซ", "๐ฌ", "๐ญ", "๐ฏ", "๐ฐ", "๐", "๐ผ", "๐ฝ", "โช", "๐", "๐", "๐", "โฉ๏ธ", "๐", "โฒ", "โบ", "๐", "๐", "๐๏ธ", "๐", "๐", "๐", "๐", "๐", "๐ ", "๐", "๐ก", "๐ข", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ป", "๐", "๐", "๐", "๐๏ธ", "๐๏ธ", "๐ต", "๐บ", "๐ฒ", "๐ด", "๐", "๐ฃ๏ธ", "๐ค๏ธ", "โฝ", "๐", "๐จ", "๐ฅ", "๐ฆ", "๐ง", "โ", "๐", "โต", "๐ค", "๐ณ๏ธ", "โด๏ธ", "๐ฅ๏ธ", "๐ข", "โ๏ธ", "๐ฉ๏ธ", "๐ซ", "๐ฌ", "๐ช", "๐บ", "๐", "๐", "๐ ", "๐ก", "๐ฐ๏ธ", "๐", "๐ธ", "๐ช", "๐ ", "๐", "โฑ๏ธ", "๐", "๐", "๐", "๐ด", "๐ต", "๐ถ", "๐ท", "๐ฟ", "๐", "๐", "๐", "๐"]
    
    static let travelNPlacesDictionary = ["Police Car Light": "๐จ", "House with Garden": "๐ก", "Ringed Planet": "๐ช", "Love Hotel": "๐ฉ", "Motor Scooter": "๐ต", "Tram": "๐", "Motor Boat": "๐ฅ๏ธ", "Moon Viewing Ceremony": "๐", "Hindu Temple": "๐", "Ring Buoy": "๐", "Bus Stop": "๐", "House": "๐ ", "Aerial Tramway": "๐ก", "Map of Japan": "๐พ", "Japanese Post Office": "๐ฃ", "Baggage Claim": "๐", "Motorway": "๐ฃ๏ธ", "Japanese Castle": "๐ฏ", "Bridge at Night": "๐", "Mountain Cableway": "๐ ", "Mosque": "๐", "Yen Banknote": "๐ด", "Railway Track": "๐ค๏ธ", "Ship": "๐ข", "Umbrella on Ground": "โฑ๏ธ", "Locomotive": "๐", "Synagogue": "๐", "Night with Stars": "๐", "Passenger Ship": "๐ณ๏ธ", "Metro": "๐", "Ferris Wheel": "๐ก", "Shooting Star": "๐ ", "Carousel Horse": "๐ ", "Bus": "๐", "Trolleybus": "๐", "Racing Car": "๐๏ธ", "Anchor": "โ", "Volcano": "๐", "Station": "๐", "Dollar Banknote": "๐ต", "Convenience Store": "๐ช", "Oncoming Bus": "๐", "Small Airplane": "๐ฉ๏ธ", "Beach with Umbrella": "๐๏ธ", "Suspension Railway": "๐", "Sunrise": "๐", "Snow-Capped Mountain": "๐๏ธ", "School": "๐ซ", "Hut": "๐", "Oncoming Police Car": "๐", "Kaaba": "๐", "Airplane Departure": "๐ซ", "Bullet Train": "๐", "Speedboat": "๐ค", "National Park": "๐๏ธ", "Parachute": "๐ช", "Houses": "๐๏ธ", "Train": "๐", "Wheel": "๐", "Airplane": "โ๏ธ", "Mountain": "โฐ๏ธ", "Fuel Pump": "โฝ", "Automobile": "๐", "Taxi": "๐", "Horizontal Traffic Light": "๐ฅ", "Sparkler": "๐", "Customs": "๐", "Oncoming Automobile": "๐", "Motorcycle": "๐๏ธ", "Seat": "๐บ", "Railway Car": "๐", "Hospital": "๐ฅ", "Tram Car": "๐", "Bicycle": "๐ฒ", "Moai": "๐ฟ", "Passport Control": "๐", "High-Speed Train": "๐", "Delivery Truck": "๐", "Person Rowing Boat": "๐ฃ", "Helicopter": "๐", "Flying Saucer": "๐ธ", "Light Rail": "๐", "Sunrise Over Mountains": "๐", "Pound Banknote": "๐ท", "Post Office": "๐ค", "Fountain": "โฒ", "Vertical Traffic Light": "๐ฆ", "Ferry": "โด๏ธ", "Construction": "๐ง", "Sunset": "๐", "Shinto Shrine": "โฉ๏ธ", "Factory": "๐ญ", "Sailboat": "โต", "Euro Banknote": "๐ถ", "Desert Island": "๐๏ธ", "Fireworks": "๐", "Playground Slide": "๐", "Department Store": "๐ฌ", "Camping": "๐๏ธ", "Fire Engine": "๐", "Statue of Liberty": "๐ฝ", "Bank": "๐ฆ", "Pickup Truck": "๐ป", "Airplane Arrival": "๐ฌ", "Monorail": "๐", "Sport Utility Vehicle": "๐", "Foggy": "๐", "Mount Fuji": "๐ป", "Church": "โช", "Ambulance": "๐", "Auto Rickshaw": "๐บ", "Stadium": "๐๏ธ", "Cityscape": "๐๏ธ", "Desert": "๐๏ธ", "Wedding": "๐", "Mountain Railway": "๐", "Oncoming Taxi": "๐", "Derelict House": "๐๏ธ", "Police Car": "๐", "Cityscape at Dusk": "๐", "Tokyo Tower": "๐ผ", "Articulated Lorry": "๐", "Satellite": "๐ฐ๏ธ", "Left Luggage": "๐", "Rocket": "๐", "Office Building": "๐ข", "Building Construction": "๐๏ธ", "Tent": "โบ", "Milky Way": "๐", "Castle": "๐ฐ", "Hotel": "๐จ", "Tractor": "๐", "Classical Building": "๐๏ธ", "Minibus": "๐", "Kick Scooter": "๐ด", "Roller Coaster": "๐ข"]
    
    static let objects = ["๐", "๐ณ๏ธ", "๐ฃ", "๐", "๐", "๐ช", "๐บ", "๐บ๏ธ", "๐งญ", "๐งฑ", "๐", "๐ฆฝ", "๐ฆผ", "๐ข๏ธ", "๐๏ธ", "๐งณ", "โ", "โณ", "โ", "โฐ", "โฑ๏ธ", "โฒ๏ธ", "๐ฐ๏ธ", "๐ก๏ธ", "โฑ๏ธ", "๐งจ", "๐", "๐", "๐", "๐", "๐", "๐", "๐งง", "๐", "๐", "๐คฟ", "๐ช", "๐ช", "๐ฎ", "๐ช", "๐งฟ", "๐ชฌ", "๐น๏ธ", "๐งธ", "๐ช", "๐ช", "๐ผ๏ธ", "๐งต", "๐ชก", "๐งถ", "๐ชข", "๐๏ธ", "๐ฟ", "๐", "๐ฏ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐ป", "๐ช", "๐ฑ", "๐ฒ", "โ๏ธ", "๐", "๐", "๐ ", "๐", "๐", "๐ป", "๐ฅ๏ธ", "๐จ๏ธ", "โจ๏ธ", "๐ฑ๏ธ", "๐ฒ๏ธ", "๐ฝ", "๐พ", "๐ฟ", "๐", "๐งฎ", "๐ฅ", "๐๏ธ", "๐ฝ๏ธ", "๐บ", "๐ท", "๐ธ", "๐น", "๐ผ", "๐", "๐", "๐ฏ๏ธ", "๐ก", "๐ฆ", "๐ฎ", "๐ช", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ฐ", "๐๏ธ", "๐", "๐", "๐ท๏ธ", "๐ฐ", "๐ช", "๐ด", "๐ต", "๐ถ", "๐ท", "๐ธ", "๐ณ", "๐งพ", "โ๏ธ", "๐ง", "๐จ", "๐ฉ", "๐ค", "๐ฅ", "๐ฆ", "๐ซ", "๐ช", "๐ฌ", "๐ญ", "๐ฎ", "๐ณ๏ธ", "โ๏ธ", "โ๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐", "๐", "๐", "๐๏ธ", "๐", "๐", "๐๏ธ", "๐๏ธ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐๏ธ", "๐", "๐", "โ๏ธ", "๐๏ธ", "๐๏ธ", "๐๏ธ", "๐", "๐", "๐", "๐", "๐", "๐๏ธ", "๐จ", "๐ช", "โ๏ธ", "โ๏ธ", "๐ ๏ธ", "๐ก๏ธ", "โ๏ธ", "๐ซ", "๐ช", "๐ก๏ธ", "๐ช", "๐ง", "๐ช", "๐ฉ", "โ๏ธ", "๐๏ธ", "โ๏ธ", "๐ฆฏ", "๐", "โ๏ธ", "๐ช", "๐งฐ", "๐งฒ", "๐ช", "โ๏ธ", "๐งช", "๐งซ", "๐งฌ", "๐ฌ", "๐ญ", "๐ก", "๐", "๐ฉธ", "๐", "๐ฉน", "๐ฉผ", "๐ฉบ", "๐ช", "๐ช", "๐ช", "๐๏ธ", "๐๏ธ", "๐ช", "๐ฝ", "๐ช ", "๐ฟ", "๐", "๐ชค", "๐ช", "๐งด", "๐งท", "๐งน", "๐งบ", "๐งป", "๐ชฃ", "๐งผ", "๐ชฅ", "๐งฝ", "๐งฏ", "๐", "๐ฌ", "โฐ๏ธ", "๐ชฆ", "โฑ๏ธ", "๐ฟ", "๐ชง", "๐ชช", "๐ฐ"]
    
    static let objectsDictionary = ["Magnifying Glass Tilted Right": "๐", "Axe": "๐ช", "Mirror": "๐ช", "Locked": "๐", "Card Index": "๐", "Razor": "๐ช", "Manual Wheelchair": "๐ฆฝ", "Locked with Key": "๐", "Oil Drum": "๐ข๏ธ", "Kite": "๐ช", "Envelope": "โ๏ธ", "Money with Wings": "๐ธ", "Headstone": "๐ชฆ", "Water Pistol": "๐ซ", "Fire Extinguisher": "๐งฏ", "Computer Disk": "๐ฝ", "Television": "๐บ", "Black Nib": "โ๏ธ", "Bomb": "๐ฃ", "Ballot Box with Ballot": "๐ณ๏ธ", "Books": "๐", "Cigarette": "๐ฌ", "Light Bulb": "๐ก", "Optical Disk": "๐ฟ", "Bar Chart": "๐", "Camera": "๐ท", "Mantelpiece Clock": "๐ฐ๏ธ", "Kitchen Knife": "๐ช", "Closed Book": "๐", "Crossed Swords": "โ๏ธ", "Amphora": "๐บ", "Diving Mask": "๐คฟ", "Confetti Ball": "๐", "Potable Water": "๐ฐ", "Package": "๐ฆ", "Page with Curl": "๐", "Closed Mailbox with Raised Flag": "๐ซ", "Paperclip": "๐", "DVD": "๐", "Movie Camera": "๐ฅ", "Crayon": "๐๏ธ", "Incoming Envelope": "๐จ", "Bucket": "๐ชฃ", "Piรฑata": "๐ช", "Framed Picture": "๐ผ๏ธ", "Basket": "๐งบ", "Outbox Tray": "๐ค", "Compass": "๐งญ", "Yo-Yo": "๐ช", "Nesting Dolls": "๐ช", "Postal Horn": "๐ฏ", "Bathtub": "๐", "Satellite Antenna": "๐ก", "Electric Plug": "๐", "File Folder": "๐", "Notebook with Decorative Cover": "๐", "Nazar Amulet": "๐งฟ", "Videocassette": "๐ผ", "Bookmark": "๐", "Red Paper Lantern": "๐ฎ", "Broom": "๐งน", "Bookmark Tabs": "๐", "Control Knobs": "๐๏ธ", "Orange Book": "๐", "Stopwatch": "โฑ๏ธ", "Locked with Pen": "๐", "Studio Microphone": "๐๏ธ", "Thermometer": "๐ก๏ธ", "Door": "๐ช", "Inbox Tray": "๐ฅ", "Party Popper": "๐", "Prayer Beads": "๐ฟ", "Link": "๐", "Round Pushpin": "๐", "Hammer": "๐จ", "Shower": "๐ฟ", "Funeral Urn": "โฑ๏ธ", "Umbrella on Ground": "โฑ๏ธ", "Ladder": "๐ช", "Fountain Pen": "๐๏ธ", "Page Facing Up": "๐", "Banjo": "๐ช", "Barber Pole": "๐", "Plunger": "๐ช ", "Envelope with Arrow": "๐ฉ", "Tear-Off Calendar": "๐", "Thread": "๐งต", "Open Mailbox with Raised Flag": "๐ฌ", "Level Slider": "๐๏ธ", "Euro Banknote": "๐ถ", "Battery": "๐", "Floppy Disk": "๐พ", "Clamp": "๐๏ธ", "Blue Book": "๐", "Magnifying Glass Tilted Left": "๐", "Teddy Bear": "๐งธ", "Wind Chime": "๐", "Scissors": "โ๏ธ", "Wastebasket": "๐๏ธ", "Clipboard": "๐", "Magic Wand": "๐ช", "Desktop Computer": "๐ฅ๏ธ", "Pen": "๐๏ธ", "Wrapped Gift": "๐", "Placard": "๐ชง", "Receipt": "๐งพ", "Camera with Flash": "๐ธ", "Dollar Banknote": "๐ต", "Keyboard": "โจ๏ธ", "Pick": "โ๏ธ", "Linked Paperclips": "๐๏ธ", "Mobile Phone with Arrow": "๐ฒ", "Person Taking Bath": "๐", "Mouse Trap": "๐ชค", "Petri Dish": "๐งซ", "Sponge": "๐งฝ", "Soap": "๐งผ", "Newspaper": "๐ฐ", "Timer Clock": "โฒ๏ธ", "Screwdriver": "๐ช", "Adhesive Bandage": "๐ฉน", "Crutch": "๐ฉผ", "Firecracker": "๐งจ", "Hook": "๐ช", "Unlocked": "๐", "Key": "๐", "Memo": "๐", "Joystick": "๐น๏ธ", "Hole": "๐ณ๏ธ", "Nut and Bolt": "๐ฉ", "Crystal Ball": "๐ฎ", "Dagger": "๐ก๏ธ", "Hourglass Not Done": "โณ", "Card File Box": "๐๏ธ", "Coffin": "โฐ๏ธ", "Safety Pin": "๐งท", "Alembic": "โ๏ธ", "Telephone": "โ๏ธ", "Balance Scale": "โ๏ธ", "Straight Ruler": "๐", "Toothbrush": "๐ชฅ", "Spiral Notepad": "๐๏ธ", "Paintbrush": "๐๏ธ", "Coin": "๐ช", "Japanese Dolls": "๐", "Old Key": "๐๏ธ", "Toolbox": "๐งฐ", "Knot": "๐ชข", "Hamsa": "๐ชฌ", "Sewing Needle": "๐ชก", "Lotion Bottle": "๐งด", "Wrench": "๐ง", "Shopping Cart": "๐", "Pound Banknote": "๐ท", "Yarn": "๐งถ", "Scroll": "๐", "Fax Machine": "๐ ", "Pill": "๐", "Candle": "๐ฏ๏ธ", "Toilet": "๐ฝ", "File Cabinet": "๐๏ธ", "Film Projector": "๐ฝ๏ธ", "E-Mail": "๐ง", "Computer Mouse": "๐ฑ๏ธ", "Hammer and Wrench": "๐ ๏ธ", "Bellhop Bell": "๐๏ธ", "Carpentry Saw": "๐ช", "Card Index Dividers": "๐๏ธ", "Brick": "๐งฑ", "Boomerang": "๐ช", "Telephone Receiver": "๐", "Closed Mailbox with Lowered Flag": "๐ช", "Chair": "๐ช", "Motorized Wheelchair": "๐ฆผ", "Window": "๐ช", "Gear": "โ๏ธ", "World Map": "๐บ๏ธ", "Shopping Bags": "๐๏ธ", "Radio": "๐ป", "Spiral Calendar": "๐๏ธ", "Shield": "๐ก๏ธ", "Money Bag": "๐ฐ", "Stethoscope": "๐ฉบ", "Film Frames": "๐๏ธ", "Label": "๐ท๏ธ", "White Cane": "๐ฆฏ", "Abacus": "๐งฎ", "Hourglass Done": "โ", "Test Tube": "๐งช", "Person in Bed": "๐", "Mobile Phone": "๐ฑ", "Luggage": "๐งณ", "Carp Streamer": "๐", "Red Envelope": "๐งง", "Chart Decreasing": "๐", "Pushpin": "๐", "Laptop": "๐ป", "Video Camera": "๐น", "DNA": "๐งฌ", "Open Book": "๐", "Green Book": "๐", "Rolled-Up Newspaper": "๐๏ธ", "Notebook": "๐", "Printer": "๐จ๏ธ", "Couch and Lamp": "๐๏ธ", "Triangular Ruler": "๐", "Love Letter": "๐", "Open File Folder": "๐", "Ledger": "๐", "Watch": "โ", "Ribbon": "๐", "Calendar": "๐", "Telescope": "๐ญ", "Magnet": "๐งฒ", "Hammer and Pick": "โ๏ธ", "Microscope": "๐ฌ", "Drop of Blood": "๐ฉธ", "Syringe": "๐", "Moai": "๐ฟ", "Pager": "๐", "Trackball": "๐ฒ๏ธ", "Alarm Clock": "โฐ", "Chart Increasing": "๐", "Flashlight": "๐ฆ", "Credit Card": "๐ณ", "Identification Card": "๐ชช", "Diya Lamp": "๐ช", "Roll of Paper": "๐งป", "Pencil": "โ๏ธ", "Yen Banknote": "๐ด", "Chains": "โ๏ธ", "Gem Stone": "๐", "Postbox": "๐ฎ", "Open Mailbox with Lowered Flag": "๐ญ", "Balloon": "๐", "Bed": "๐๏ธ"]
    
    static let symbols = ["๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "โฃ๏ธ", "๐", "โค๏ธโ๐ฅ", "โค๏ธโ๐ฉน", "โค๏ธ", "๐งก", "๐", "๐", "๐", "๐", "๐ค", "๐ค", "๐ค", "๐ฏ", "๐ข", "๐ฌ", "๐๏ธโ๐จ๏ธ", "๐จ๏ธ", "๐ฏ๏ธ", "๐ญ", "๐ค", "๐ฎ", "โจ๏ธ", "๐", "๐", "๐", "๐ง", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐ ", "๐", "๐ก", "๐", "๐ข", "๐", "๐ฃ", "๐", "๐ค", "๐", "๐ฅ", "๐", "๐ฆ", "๐", "โ ๏ธ", "โฅ๏ธ", "โฆ๏ธ", "โฃ๏ธ", "๐", "๐", "๐ด", "๐", "๐", "๐", "๐", "๐ข", "๐ฃ", "๐ฏ", "๐", "๐", "๐ต", "๐ถ", "๐น", "๐", "๐ง", "๐ฎ", "๐ฐ", "โฟ", "๐น", "๐บ", "๐ป", "๐ผ", "๐พ", "โ ๏ธ", "๐ธ", "โ", "๐ซ", "๐ณ", "๐ญ", "๐ฏ", "๐ฑ", "๐ท", "๐ต", "๐", "โข๏ธ", "โฃ๏ธ", "โฌ๏ธ", "โ๏ธ", "โก๏ธ", "โ๏ธ", "โฌ๏ธ", "โ๏ธ", "โฌ๏ธ", "โ๏ธ", "โ๏ธ", "โ๏ธ", "โฉ๏ธ", "โช๏ธ", "โคด๏ธ", "โคต๏ธ", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "๐", "โ๏ธ", "๐๏ธ", "โก๏ธ", "โธ๏ธ", "โฏ๏ธ", "โ๏ธ", "โฆ๏ธ", "โช๏ธ", "โฎ๏ธ", "๐", "๐ฏ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "โ", "๐", "๐", "๐", "โถ๏ธ", "โฉ", "โญ๏ธ", "โฏ๏ธ", "โ๏ธ", "โช", "โฎ๏ธ", "๐ผ", "โซ", "๐ฝ", "โฌ", "โธ๏ธ", "โน๏ธ", "โบ๏ธ", "โ๏ธ", "๐ฆ", "๐", "๐", "๐ถ", "๐ณ", "๐ด", "โ๏ธ", "โ๏ธ", "โ๏ธ", "โ", "โ", "โ", "๐ฐ", "โพ๏ธ", "โผ๏ธ", "โ๏ธ", "โ", "โ", "โ", "โ", "ใฐ๏ธ", "๐ฑ", "๐ฒ", "โ๏ธ", "โป๏ธ", "โ๏ธ", "๐ฑ", "๐", "๐ฐ", "โญ", "โ", "โ๏ธ", "โ๏ธ", "โ", "โ", "โฐ", "โฟ", "ใฝ๏ธ", "โณ๏ธ", "โด๏ธ", "โ๏ธ", "ยฉ๏ธ", "ยฎ๏ธ", "โข๏ธ", "#๏ธโฃ", "*๏ธโฃ", "0๏ธโฃ", "1๏ธโฃ", "2๏ธโฃ", "3๏ธโฃ", "4๏ธโฃ", "5๏ธโฃ", "6๏ธโฃ", "7๏ธโฃ", "8๏ธโฃ", "9๏ธโฃ", "๐", "๐ ", "๐ก", "๐ข", "๐ฃ", "๐ค", "๐ฐ๏ธ", "๐", "๐ฑ๏ธ", "๐", "๐", "๐", "โน๏ธ", "๐", "โ๏ธ", "๐", "๐", "๐พ๏ธ", "๐", "๐ฟ๏ธ", "๐", "๐", "๐", "๐", "๐๏ธ", "๐ท๏ธ", "๐ถ", "๐ฏ", "๐", "๐น", "๐", "๐ฒ", "๐", "๐ธ", "๐ด", "๐ณ", "ใ๏ธ", "ใ๏ธ", "๐บ", "๐ต", "๐ด", "๐ ", "๐ก", "๐ข", "๐ต", "๐ฃ", "๐ค", "โซ", "โช", "๐ฅ", "๐ง", "๐จ", "๐ฉ", "๐ฆ", "๐ช", "๐ซ", "โฌ", "โฌ", "โผ๏ธ", "โป๏ธ", "โพ", "โฝ", "โช๏ธ", "โซ๏ธ", "๐ถ", "๐ท", "๐ธ", "๐น", "๐บ", "๐ป", "๐ ", "๐", "๐ณ", "๐ฒ"]
    
    static let symbolsDictionary = ["Large Orange Diamond": "๐ถ", "Keycap Digit Six": "6๏ธโฃ", "Yellow Heart": "๐", "Red Question Mark": "โ", "Wavy Dash": "ใฐ๏ธ", "Clockwise Vertical Arrows": "๐", "Japanese โSecretโ Button": "ใ๏ธ", "Chart Increasing with Yen": "๐น", "Eject Button": "โ๏ธ", "White Question Mark": "โ", "Dim Button": "๐", "Japanese โNot Free of Chargeโ Button": "๐ถ", "Left-Right Arrow": "โ๏ธ", "Curly Loop": "โฐ", "Potable Water": "๐ฐ", "Left Speech Bubble": "๐จ๏ธ", "White Large Square": "โฌ", "Place of Worship": "๐", "Eight-Thirty": "๐ฃ", "Hollow Red Circle": "โญ", "Leo": "โ", "Input Numbers": "๐ข", "Japanese โProhibitedโ Button": "๐ฒ", "Stop Sign": "๐", "Up Arrow": "โฌ๏ธ", "No Mobile Phones": "๐ต", "Aquarius": "โ", "Hot Springs": "โจ๏ธ", "No Smoking": "๐ญ", "Keycap Digit Zero": "0๏ธโฃ", "ID Button": "๐", "Large Blue Diamond": "๐ท", "Right Anger Bubble": "๐ฏ๏ธ", "Top Arrow": "๐", "Purple Circle": "๐ฃ", "White Medium Square": "โป๏ธ", "Joker": "๐", "Womenโs Room": "๐บ", "Input Latin Letters": "๐ค", "Ophiuchus": "โ", "Japanese โVacancyโ Button": "๐ณ", "Vibration Mode": "๐ณ", "On! Arrow": "๐", "Check Mark Button": "โ", "Litter in Bin Sign": "๐ฎ", "Part Alternation Mark": "ใฝ๏ธ", "Aries": "โ", "Bright Button": "๐", "Japanese โService Chargeโ Button": "๐๏ธ", "Red Circle": "๐ด", "Eight OโClock": "๐", "Yellow Square": "๐จ", "Red Exclamation Mark": "โ", "Up-Left Arrow": "โ๏ธ", "Japanese โBargainโ Button": "๐", "Red Triangle Pointed Down": "๐ป", "Water Closet": "๐พ", "Japanese โNo Vacancyโ Button": "๐ต", "Nine-Thirty": "๐ค", "Last Track Button": "โฎ๏ธ", "One-Thirty": "๐", "Antenna Bars": "๐ถ", "Heart Exclamation": "โฃ๏ธ", "Up! Button": "๐", "Heart Decoration": "๐", "Upwards Button": "๐ผ", "Pause Button": "โธ๏ธ", "Left Arrow": "โฌ๏ธ", "Two OโClock": "๐", "Postal Horn": "๐ฏ", "Loudspeaker": "๐ข", "Double Exclamation Mark": "โผ๏ธ", "Check Mark": "โ๏ธ", "Bell": "๐", "Dotted Six-Pointed Star": "๐ฏ", "Cool Button": "๐", "Name Badge": "๐", "Pisces": "โ", "Radio Button": "๐", "Japanese โFree of Chargeโ Button": "๐", "Japanese โMonthly Amountโ Button": "๐ท๏ธ", "Currency Exchange": "๐ฑ", "Keycap Digit Three": "3๏ธโฃ", "White Square Button": "๐ณ", "Heart on Fire": "โค๏ธโ๐ฅ", "Peace Symbol": "โฎ๏ธ", "Black Heart": "๐ค", "Exclamation Question Mark": "โ๏ธ", "Keycap Digit Seven": "7๏ธโฃ", "Orthodox Cross": "โฆ๏ธ", "New Button": "๐", "Eight-Pointed Star": "โด๏ธ", "Diamond Suit": "โฆ๏ธ", "Red Square": "๐ฅ", "Black Square Button": "๐ฒ", "Down-Right Arrow": "โ๏ธ", "Keycap Digit Eight": "8๏ธโฃ", "No Bicycles": "๐ณ", "Keycap Digit Four": "4๏ธโฃ", "Brown Circle": "๐ค", "Black Large Square": "โฌ", "Four-Thirty": "๐", "Green Circle": "๐ข", "Black Medium-Small Square": "โพ", "Children Crossing": "๐ธ", "Musical Notes": "๐ถ", "Three-Thirty": "๐", "Play or Pause Button": "โฏ๏ธ", "Japanese โCongratulationsโ Button": "ใ๏ธ", "Infinity": "โพ๏ธ", "Menorah": "๐", "Keycap Digit Two": "2๏ธโฃ", "Menโs Room": "๐น", "Up-Down Arrow": "โ๏ธ", "Star of David": "โก๏ธ", "Fleur-de-lis": "โ๏ธ", "Atom Symbol": "โ๏ธ", "Speech Balloon": "๐ฌ", "Japanese โDiscountโ Button": "๐น", "Keycap Number Sign": "#๏ธโฃ", "Muted Speaker": "๐", "Green Heart": "๐", "Megaphone": "๐ฃ", "Five OโClock": "๐", "Six-Thirty": "๐ก", "Bell with Slash": "๐", "No Pedestrians": "๐ท", "Plus": "โ", "Heart Suit": "โฅ๏ธ", "Elevator": "๐", "Keycap: 10": "๐", "Broken Heart": "๐", "Purple Square": "๐ช", "Six OโClock": "๐", "Reverse Button": "โ๏ธ", "Vs Button": "๐", "Hundred Points": "๐ฏ", "Eight-Spoked Asterisk": "โณ๏ธ", "Cross Mark": "โ", "White Flower": "๐ฎ", "Medical Symbol": "โ๏ธ", "Anger Symbol": "๐ข", "Keycap Digit Nine": "9๏ธโฃ", "Input Latin Lowercase": "๐ก", "Orange Square": "๐ง", "Japanese โReservedโ Button": "๐ฏ", "Yin Yang": "โฏ๏ธ", "Circled M": "โ๏ธ", "Fast Down Button": "โฌ", "Small Blue Diamond": "๐น", "Thought Balloon": "๐ญ", "White Exclamation Mark": "โ", "Female Sign": "โ๏ธ", "Blue Square": "๐ฆ", "Two Hearts": "๐", "Twelve-Thirty": "๐ง", "Eye in Speech Bubble": "๐๏ธโ๐จ๏ธ", "Blue Circle": "๐ต", "Trident Emblem": "๐ฑ", "Green Square": "๐ฉ", "Keycap Digit One": "1๏ธโฃ", "Diamond with a Dot": "๐ ", "Brown Heart": "๐ค", "Check Box with Check": "โ๏ธ", "Keycap Asterisk": "*๏ธโฃ", "Radioactive": "โข๏ธ", "Trade Mark": "โข๏ธ", "Divide": "โ", "A Button (Blood Type)": "๐ฐ๏ธ", "Japanese โHereโ Button": "๐", "Black Small Square": "โช๏ธ", "Play Button": "โถ๏ธ", "White Circle": "โช", "Downwards Button": "๐ฝ", "Blue Heart": "๐", "Sparkling Heart": "๐", "Sparkle": "โ๏ธ", "Heart with Ribbon": "๐", "ATM Sign": "๐ง", "Fast Up Button": "โซ", "Orange Circle": "๐ ", "Two-Thirty": "๐", "Zzz": "๐ค", "Up-Right Arrow": "โ๏ธ", "White Heart": "๐ค", "Stop Button": "โน๏ธ", "Wheelchair Symbol": "โฟ", "Left Arrow Curving Right": "โช๏ธ", "Sagittarius": "โ", "Mobile Phone Off": "๐ด", "Brown Square": "๐ซ", "Right Arrow Curving Up": "โคด๏ธ", "Warning": "โ ๏ธ", "Orange Heart": "๐งก", "Free Button": "๐", "Black Medium Square": "โผ๏ธ", "No Littering": "๐ฏ", "Non-Potable Water": "๐ฑ", "Three OโClock": "๐", "Eleven OโClock": "๐", "Musical Note": "๐ต", "Minus": "โ", "Red Heart": "โค๏ธ", "Libra": "โ", "Gemini": "โ", "No Entry": "โ", "Heavy Equals Sign": "๐ฐ", "Wheel of Dharma": "โธ๏ธ", "Prohibited": "๐ซ", "Cyclone": "๐", "Input Symbols": "๐ฃ", "Repeat Button": "๐", "Fast Reverse Button": "โช", "Virgo": "โ", "Capricorn": "โ", "Purple Heart": "๐", "Scorpio": "โ", "Barber Pole": "๐", "Speaker Medium Volume": "๐", "Japanese Symbol for Beginner": "๐ฐ", "NG Button": "๐", "Counterclockwise Arrows Button": "๐", "Double Curly Loop": "โฟ", "Registered": "ยฎ๏ธ", "White Small Square": "โซ๏ธ", "Recycling Symbol": "โป๏ธ", "Keycap Digit Five": "5๏ธโฃ", "Mahjong Red Dragon": "๐", "Right Arrow Curving Down": "โคต๏ธ", "End Arrow": "๐", "OK Button": "๐", "O Button (Blood Type)": "๐พ๏ธ", "Japanese โOpen for Businessโ Button": "๐บ", "Right Arrow Curving Left": "โฉ๏ธ", "White Medium-Small Square": "โฝ", "Heart with Arrow": "๐", "Japanese โApplicationโ Button": "๐ธ", "Red Triangle Pointed Up": "๐บ", "Taurus": "โ", "Mending Heart": "โค๏ธโ๐ฉน", "Five-Thirty": "๐ ", "Soon Arrow": "๐", "Baby Symbol": "๐ผ", "One OโClock": "๐", "CL Button": "๐", "SOS Button": "๐", "Japanese โPassing Gradeโ Button": "๐ด", "Nine OโClock": "๐", "No One Under Eighteen": "๐", "Ten-Thirty": "๐ฅ", "Input Latin Uppercase": "๐ ", "Growing Heart": "๐", "Back Arrow": "๐", "Star and Crescent": "โช๏ธ", "Repeat Single Button": "๐", "Fast-Forward Button": "โฉ", "Seven OโClock": "๐", "Biohazard": "โฃ๏ธ", "Flower Playing Cards": "๐ด", "Cinema": "๐ฆ", "Spade Suit": "โ ๏ธ", "Ten OโClock": "๐", "Cross Mark Button": "โ", "Revolving Hearts": "๐", "Cancer": "โ", "Shuffle Tracks Button": "๐", "B Button (Blood Type)": "๐ฑ๏ธ", "Eleven-Thirty": "๐ฆ", "Latin Cross": "โ๏ธ", "Seven-Thirty": "๐ข", "Twelve OโClock": "๐", "Black Circle": "โซ", "Om": "๐๏ธ", "Speaker Low Volume": "๐", "Down Arrow": "โฌ๏ธ", "Copyright": "ยฉ๏ธ", "Male Sign": "โ๏ธ", "AB Button (Blood Type)": "๐", "Next Track Button": "โญ๏ธ", "Information": "โน๏ธ", "Down-Left Arrow": "โ๏ธ", "Speaker High Volume": "๐", "Beating Heart": "๐", "P Button": "๐ฟ๏ธ", "Club Suit": "โฃ๏ธ", "Small Orange Diamond": "๐ธ", "Four OโClock": "๐", "Yellow Circle": "๐ก", "Record Button": "โบ๏ธ", "Restroom": "๐ป", "Right Arrow": "โก๏ธ", "Heavy Dollar Sign": "๐ฒ", "Japanese โAcceptableโ Button": "๐", "Multiply": "โ๏ธ"]
    
    static let flags = ["๐", "๐ฉ", "๐", "๐ด", "๐ณ๏ธ", "๐ณ๏ธโ๐", "๐ณ๏ธโโง๏ธ", "๐ดโโ ๏ธ", "๐ฆ๐จ", "๐ฆ๐ฉ", "๐ฆ๐ช", "๐ฆ๐ซ", "๐ฆ๐ฌ", "๐ฆ๐ฎ", "๐ฆ๐ฑ", "๐ฆ๐ฒ", "๐ฆ๐ด", "๐ฆ๐ถ", "๐ฆ๐ท", "๐ฆ๐ธ", "๐ฆ๐น", "๐ฆ๐บ", "๐ฆ๐ผ", "๐ฆ๐ฝ", "๐ฆ๐ฟ", "๐ง๐ฆ", "๐ง๐ง", "๐ง๐ฉ", "๐ง๐ช", "๐ง๐ซ", "๐ง๐ฌ", "๐ง๐ญ", "๐ง๐ฎ", "๐ง๐ฏ", "๐ง๐ฑ", "๐ง๐ฒ", "๐ง๐ณ", "๐ง๐ด", "๐ง๐ถ", "๐ง๐ท", "๐ง๐ธ", "๐ง๐น", "๐ง๐ป", "๐ง๐ผ", "๐ง๐พ", "๐ง๐ฟ", "๐จ๐ฆ", "๐จ๐จ", "๐จ๐ฉ", "๐จ๐ซ", "๐จ๐ฌ", "๐จ๐ญ", "๐จ๐ฎ", "๐จ๐ฐ", "๐จ๐ฑ", "๐จ๐ฒ", "๐จ๐ณ", "๐จ๐ด", "๐จ๐ต", "๐จ๐ท", "๐จ๐บ", "๐จ๐ป", "๐จ๐ผ", "๐จ๐ฝ", "๐จ๐พ", "๐จ๐ฟ", "๐ฉ๐ช", "๐ฉ๐ฌ", "๐ฉ๐ฏ", "๐ฉ๐ฐ", "๐ฉ๐ฒ", "๐ฉ๐ด", "๐ฉ๐ฟ", "๐ช๐ฆ", "๐ช๐จ", "๐ช๐ช", "๐ช๐ฌ", "๐ช๐ญ", "๐ช๐ท", "๐ช๐ธ", "๐ช๐น", "๐ช๐บ", "๐ซ๐ฎ", "๐ซ๐ฏ", "๐ซ๐ฐ", "๐ซ๐ฒ", "๐ซ๐ด", "๐ซ๐ท", "๐ฌ๐ฆ", "๐ฌ๐ง", "๐ฌ๐ฉ", "๐ฌ๐ช", "๐ฌ๐ซ", "๐ฌ๐ฌ", "๐ฌ๐ญ", "๐ฌ๐ฎ", "๐ฌ๐ฑ", "๐ฌ๐ฒ", "๐ฌ๐ณ", "๐ฌ๐ต", "๐ฌ๐ถ", "๐ฌ๐ท", "๐ฌ๐ธ", "๐ฌ๐น", "๐ฌ๐บ", "๐ฌ๐ผ", "๐ฌ๐พ", "๐ญ๐ฐ", "๐ญ๐ฒ", "๐ญ๐ณ", "๐ญ๐ท", "๐ญ๐น", "๐ญ๐บ", "๐ฎ๐จ", "๐ฎ๐ฉ", "๐ฎ๐ช", "๐ฎ๐ฑ", "๐ฎ๐ฒ", "๐ฎ๐ณ", "๐ฎ๐ด", "๐ฎ๐ถ", "๐ฎ๐ท", "๐ฎ๐ธ", "๐ฎ๐น", "๐ฏ๐ช", "๐ฏ๐ฒ", "๐ฏ๐ด", "๐ฏ๐ต", "๐ฐ๐ช", "๐ฐ๐ฌ", "๐ฐ๐ญ", "๐ฐ๐ฎ", "๐ฐ๐ฒ", "๐ฐ๐ณ", "๐ฐ๐ต", "๐ฐ๐ท", "๐ฐ๐ผ", "๐ฐ๐พ", "๐ฐ๐ฟ", "๐ฑ๐ฆ", "๐ฑ๐ง", "๐ฑ๐จ", "๐ฑ๐ฎ", "๐ฑ๐ฐ", "๐ฑ๐ท", "๐ฑ๐ธ", "๐ฑ๐น", "๐ฑ๐บ", "๐ฑ๐ป", "๐ฑ๐พ", "๐ฒ๐ฆ", "๐ฒ๐จ", "๐ฒ๐ฉ", "๐ฒ๐ช", "๐ฒ๐ซ", "๐ฒ๐ฌ", "๐ฒ๐ญ", "๐ฒ๐ฐ", "๐ฒ๐ฑ", "๐ฒ๐ฒ", "๐ฒ๐ณ", "๐ฒ๐ด", "๐ฒ๐ต", "๐ฒ๐ถ", "๐ฒ๐ท", "๐ฒ๐ธ", "๐ฒ๐น", "๐ฒ๐บ", "๐ฒ๐ป", "๐ฒ๐ผ", "๐ฒ๐ฝ", "๐ฒ๐พ", "๐ฒ๐ฟ", "๐ณ๐ฆ", "๐ณ๐จ", "๐ณ๐ช", "๐ณ๐ซ", "๐ณ๐ฌ", "๐ณ๐ฎ", "๐ณ๐ฑ", "๐ณ๐ด", "๐ณ๐ต", "๐ณ๐ท", "๐ณ๐บ", "๐ณ๐ฟ", "๐ด๐ฒ", "๐ต๐ฆ", "๐ต๐ช", "๐ต๐ซ", "๐ต๐ฌ", "๐ต๐ญ", "๐ต๐ฐ", "๐ต๐ฑ", "๐ต๐ฒ", "๐ต๐ณ", "๐ต๐ท", "๐ต๐ธ", "๐ต๐น", "๐ต๐ผ", "๐ต๐พ", "๐ถ๐ฆ", "๐ท๐ช", "๐ท๐ด", "๐ท๐ธ", "๐ท๐บ", "๐ท๐ผ", "๐ธ๐ฆ", "๐ธ๐ง", "๐ธ๐จ", "๐ธ๐ฉ", "๐ธ๐ช", "๐ธ๐ฌ", "๐ธ๐ญ", "๐ธ๐ฎ", "๐ธ๐ฏ", "๐ธ๐ฐ", "๐ธ๐ฑ", "๐ธ๐ฒ", "๐ธ๐ณ", "๐ธ๐ด", "๐ธ๐ท", "๐ธ๐ธ", "๐ธ๐น", "๐ธ๐ป", "๐ธ๐ฝ", "๐ธ๐พ", "๐ธ๐ฟ", "๐น๐ฆ", "๐น๐จ", "๐น๐ฉ", "๐น๐ซ", "๐น๐ฌ", "๐น๐ญ", "๐น๐ฏ", "๐น๐ฐ", "๐น๐ฑ", "๐น๐ฒ", "๐น๐ณ", "๐น๐ด", "๐น๐ท", "๐น๐น", "๐น๐ป", "๐น๐ผ", "๐น๐ฟ", "๐บ๐ฆ", "๐บ๐ฌ", "๐บ๐ฒ", "๐บ๐ณ", "๐บ๐ธ", "๐บ๐พ", "๐บ๐ฟ", "๐ป๐ฆ", "๐ป๐จ", "๐ป๐ช", "๐ป๐ฌ", "๐ป๐ฎ", "๐ป๐ณ", "๐ป๐บ", "๐ผ๐ซ", "๐ผ๐ธ", "๐ฝ๐ฐ", "๐พ๐ช", "๐พ๐น", "๐ฟ๐ฆ", "๐ฟ๐ฒ", "๐ฟ๐ผ", "๐ด๓ ง๓ ข๓ ฅ๓ ฎ๓ ง๓ ฟ", "๐ด๓ ง๓ ข๓ ณ๓ ฃ๓ ด๓ ฟ", "๐ด๓ ง๓ ข๓ ท๓ ฌ๓ ณ๓ ฟ"]
    
    static let flagDictionary = ["Flag: Qatar": "๐ถ๐ฆ", "Flag: Turkey": "๐น๐ท", "Flag: Kazakhstan": "๐ฐ๐ฟ", "Flag: Czechia": "๐จ๐ฟ", "Flag: Malaysia": "๐ฒ๐พ", "Flag: Guatemala": "๐ฌ๐น", "White Flag": "๐ณ๏ธ", "Chequered Flag": "๐", "Flag: Cyprus": "๐จ๐พ", "Flag: Fiji": "๐ซ๐ฏ", "Flag: Serbia": "๐ท๐ธ", "Flag: Taiwan": "๐น๐ผ", "Flag: Montserrat": "๐ฒ๐ธ", "Flag: Panama": "๐ต๐ฆ", "Flag: European Union": "๐ช๐บ", "Flag: Chad": "๐น๐ฉ", "Flag: Peru": "๐ต๐ช", "Flag: Iraq": "๐ฎ๐ถ", "Flag: South Korea": "๐ฐ๐ท", "Flag: Albania": "๐ฆ๐ฑ", "Flag: Samoa": "๐ผ๐ธ", "Pirate Flag": "๐ดโโ ๏ธ", "Flag: China": "๐จ๐ณ", "Flag: Zimbabwe": "๐ฟ๐ผ", "Flag: Sri Lanka": "๐ฑ๐ฐ", "Flag: Marshall Islands": "๐ฒ๐ญ", "Flag: Honduras": "๐ญ๐ณ", "Flag: Monaco": "๐ฒ๐จ", "Triangular Flag": "๐ฉ", "Flag: Tuvalu": "๐น๐ป", "Flag: Colombia": "๐จ๐ด", "Flag: Barbados": "๐ง๐ง", "Flag: Italy": "๐ฎ๐น", "Flag: Equatorial Guinea": "๐ฌ๐ถ", "Flag: Falkland Islands": "๐ซ๐ฐ", "Flag: St. Pierre & Miquelon": "๐ต๐ฒ", "Flag: Tanzania": "๐น๐ฟ", "Flag: Papua New Guinea": "๐ต๐ฌ", "Flag: Eswatini": "๐ธ๐ฟ", "Flag: Tristan Da Cunha": "๐น๐ฆ", "Flag: Burundi": "๐ง๐ฎ", "Flag: Faroe Islands": "๐ซ๐ด", "Flag: Diego Garcia": "๐ฉ๐ฌ", "Flag: Maldives": "๐ฒ๐ป", "Flag: British Virgin Islands": "๐ป๐ฌ", "Flag: Mongolia": "๐ฒ๐ณ", "Flag: Bulgaria": "๐ง๐ฌ", "Flag: New Caledonia": "๐ณ๐จ", "Flag: Tokelau": "๐น๐ฐ", "Flag: French Polynesia": "๐ต๐ซ", "Flag: Spain": "๐ช๐ธ", "Flag: St. Lucia": "๐ฑ๐จ", "Flag: Ceuta & Melilla": "๐ช๐ฆ", "Flag: Antigua & Barbuda": "๐ฆ๐ฌ", "Flag: Finland": "๐ซ๐ฎ", "Flag: Kuwait": "๐ฐ๐ผ", "Flag: Gibraltar": "๐ฌ๐ฎ", "Flag: Laos": "๐ฑ๐ฆ", "Flag: Sรฃo Tomรฉ & Prรญncipe": "๐ธ๐น", "Flag: Canada": "๐จ๐ฆ", "Flag: Sudan": "๐ธ๐ฉ", "Flag: Vatican City": "๐ป๐ฆ", "Flag: Pakistan": "๐ต๐ฐ", "Flag: United Nations": "๐บ๐ณ", "Flag: Antarctica": "๐ฆ๐ถ", "Black Flag": "๐ด", "Flag: Bosnia & Herzegovina": "๐ง๐ฆ", "Flag: Benin": "๐ง๐ฏ", "Flag: Eritrea": "๐ช๐ท", "Flag: France": "๐ซ๐ท", "Flag: Ghana": "๐ฌ๐ญ", "Flag: Niue": "๐ณ๐บ", "Flag: Ukraine": "๐บ๐ฆ", "Flag: St. Vincent & Grenadines": "๐ป๐จ", "Flag: Senegal": "๐ธ๐ณ", "Flag: Djibouti": "๐ฉ๐ฏ", "Flag: Guadeloupe": "๐ฌ๐ต", "Flag: Japan": "๐ฏ๐ต", "Flag: Zambia": "๐ฟ๐ฒ", "Flag: Montenegro": "๐ฒ๐ช", "Flag: North Macedonia": "๐ฒ๐ฐ", "Flag: Curaรงao": "๐จ๐ผ", "Flag: Tunisia": "๐น๐ณ", "Flag: Germany": "๐ฉ๐ช", "Flag: Cuba": "๐จ๐บ", "Flag: Rwanda": "๐ท๐ผ", "Flag: Sint Maarten": "๐ธ๐ฝ", "Flag: Canary Islands": "๐ฎ๐จ", "Flag: Iran": "๐ฎ๐ท", "Flag: American Samoa": "๐ฆ๐ธ", "Flag: Mali": "๐ฒ๐ฑ", "Flag: Turkmenistan": "๐น๐ฒ", "Flag: New Zealand": "๐ณ๐ฟ", "Flag: Bermuda": "๐ง๐ฒ", "Flag: Lebanon": "๐ฑ๐ง", "Flag: Botswana": "๐ง๐ผ", "Flag: Norway": "๐ณ๐ด", "Flag: South Sudan": "๐ธ๐ธ", "Flag: Jordan": "๐ฏ๐ด", "Flag: Uzbekistan": "๐บ๐ฟ", "Flag: Wallis & Futuna": "๐ผ๐ซ", "Flag: Aruba": "๐ฆ๐ผ", "Flag: Andorra": "๐ฆ๐ฉ", "Flag: French Guiana": "๐ฌ๐ซ", "Flag: Slovakia": "๐ธ๐ฐ", "Flag: Myanmar (Burma)": "๐ฒ๐ฒ", "Flag: British Indian Ocean Territory": "๐ฎ๐ด", "Flag: Brunei": "๐ง๐ณ", "Flag: Guyana": "๐ฌ๐พ", "Flag: Kenya": "๐ฐ๐ช", "Flag: St. Kitts & Nevis": "๐ฐ๐ณ", "Flag: Suriname": "๐ธ๐ท", "Flag: Timor-Leste": "๐น๐ฑ", "Flag: Sierra Leone": "๐ธ๐ฑ", "Flag: Denmark": "๐ฉ๐ฐ", "Flag: Western Sahara": "๐ช๐ญ", "Flag: Ecuador": "๐ช๐จ", "Flag: Congo - Kinshasa": "๐จ๐ฉ", "Flag: Luxembourg": "๐ฑ๐บ", "Flag: Togo": "๐น๐ฌ", "Flag: Madagascar": "๐ฒ๐ฌ", "Flag: Hong Kong SAR China": "๐ญ๐ฐ", "Flag: Cocos (Keeling) Islands": "๐จ๐จ", "Flag: San Marino": "๐ธ๐ฒ", "Crossed Flags": "๐", "Flag: Palau": "๐ต๐ผ", "Flag: Haiti": "๐ญ๐น", "Flag: Chile": "๐จ๐ฑ", "Flag: Martinique": "๐ฒ๐ถ", "Flag: Poland": "๐ต๐ฑ", "Flag: Argentina": "๐ฆ๐ท", "Flag: Angola": "๐ฆ๐ด", "Flag: Netherlands": "๐ณ๐ฑ", "Flag: Nepal": "๐ณ๐ต", "Flag: Kyrgyzstan": "๐ฐ๐ฌ", "Flag: Bahamas": "๐ง๐ธ", "Flag: Russia": "๐ท๐บ", "Flag: Mauritius": "๐ฒ๐บ", "Flag: Scotland": "๐ด๓ ง๓ ข๓ ณ๓ ฃ๓ ด๓ ฟ", "Flag: Uruguay": "๐บ๐พ", "Flag: Turks & Caicos Islands": "๐น๐จ", "Flag: Singapore": "๐ธ๐ฌ", "Flag: Libya": "๐ฑ๐พ", "Flag: Israel": "๐ฎ๐ฑ", "Flag: Iceland": "๐ฎ๐ธ", "Flag: St. Helena": "๐ธ๐ญ", "Flag: Switzerland": "๐จ๐ญ", "Flag: Isle of Man": "๐ฎ๐ฒ", "Flag: Liberia": "๐ฑ๐ท", "Flag: Mozambique": "๐ฒ๐ฟ", "Flag: Nigeria": "๐ณ๐ฌ", "Flag: Trinidad & Tobago": "๐น๐น", "Flag: United Kingdom": "๐ฌ๐ง", "Flag: Jersey": "๐ฏ๐ช", "Flag: Belarus": "๐ง๐พ", "Flag: Guinea": "๐ฌ๐ณ", "Flag: Wales": "๐ด๓ ง๓ ข๓ ท๓ ฌ๓ ณ๓ ฟ", "Flag: Malawi": "๐ฒ๐ผ", "Flag: Belgium": "๐ง๐ช", "Flag: Afghanistan": "๐ฆ๐ซ", "Flag: Venezuela": "๐ป๐ช", "Flag: Niger": "๐ณ๐ช", "Flag: Morocco": "๐ฒ๐ฆ", "Flag: Brazil": "๐ง๐ท", "Flag: Vanuatu": "๐ป๐บ", "Transgender Flag": "๐ณ๏ธโโง๏ธ", "Flag: Cambodia": "๐ฐ๐ญ", "Flag: Rรฉunion": "๐ท๐ช", "Flag: Hungary": "๐ญ๐บ", "Flag: Congo - Brazzaville": "๐จ๐ฌ", "Flag: United Arab Emirates": "๐ฆ๐ช", "Flag: Yemen": "๐พ๐ช", "Flag: Austria": "๐ฆ๐น", "Flag: United States": "๐บ๐ธ", "Flag: Belize": "๐ง๐ฟ", "Flag: Romania": "๐ท๐ด", "Flag: Estonia": "๐ช๐ช", "Flag: Solomon Islands": "๐ธ๐ง", "Flag: Mayotte": "๐พ๐น", "Flag: Heard & McDonald Islands": "๐ญ๐ฒ", "Flag: El Salvador": "๐ธ๐ป", "Flag: Guam": "๐ฌ๐บ", "Flag: Pitcairn Islands": "๐ต๐ณ", "Flag: Costa Rica": "๐จ๐ท", "Flag: Latvia": "๐ฑ๐ป", "Flag: Namibia": "๐ณ๐ฆ", "Flag: Uganda": "๐บ๐ฌ", "Flag: Cayman Islands": "๐ฐ๐พ", "Flag: Jamaica": "๐ฏ๐ฒ", "Flag: Guinea-Bissau": "๐ฌ๐ผ", "Flag: Christmas Island": "๐จ๐ฝ", "Flag: Burkina Faso": "๐ง๐ซ", "Flag: Bahrain": "๐ง๐ญ", "Flag: Gambia": "๐ฌ๐ฒ", "Flag: Puerto Rico": "๐ต๐ท", "Flag: Svalbard & Jan Mayen": "๐ธ๐ฏ", "Flag: Australia": "๐ฆ๐บ", "Flag: India": "๐ฎ๐ณ", "Flag: Somalia": "๐ธ๐ด", "Flag: St. Barthรฉlemy": "๐ง๐ฑ", "Flag: Slovenia": "๐ธ๐ฎ", "Flag: Indonesia": "๐ฎ๐ฉ", "Flag: Moldova": "๐ฒ๐ฉ", "Flag: Central African Republic": "๐จ๐ซ", "Flag: Norfolk Island": "๐ณ๐ซ", "Flag: Malta": "๐ฒ๐น", "Flag: Oman": "๐ด๐ฒ", "Flag: Tonga": "๐น๐ด", "Rainbow Flag": "๐ณ๏ธโ๐", "Flag: Algeria": "๐ฉ๐ฟ", "Flag: Seychelles": "๐ธ๐จ", "Flag: Kosovo": "๐ฝ๐ฐ", "Flag: Palestinian Territories": "๐ต๐ธ", "Flag: Micronesia": "๐ซ๐ฒ", "Flag: Cook Islands": "๐จ๐ฐ", "Flag: Tajikistan": "๐น๐ฏ", "Flag: Azerbaijan": "๐ฆ๐ฟ", "Flag: Cape Verde": "๐จ๐ป", "Flag: Lithuania": "๐ฑ๐น", "Flag: U.S. Virgin Islands": "๐ป๐ฎ", "Flag: Armenia": "๐ฆ๐ฒ", "Flag: North Korea": "๐ฐ๐ต", "Flag: French Southern Territories": "๐น๐ซ", "Flag: South Africa": "๐ฟ๐ฆ", "Flag: Portugal": "๐ต๐น", "Flag: Syria": "๐ธ๐พ", "Flag: Kiribati": "๐ฐ๐ฎ", "Flag: Nauru": "๐ณ๐ท", "Flag: Ascension Island": "๐ฆ๐จ", "Flag: Grenada": "๐ฌ๐ฉ", "Flag: Saudi Arabia": "๐ธ๐ฆ", "Flag: Paraguay": "๐ต๐พ", "Flag: Liechtenstein": "๐ฑ๐ฎ", "Flag: Sweden": "๐ธ๐ช", "Flag: Dominican Republic": "๐ฉ๐ด", "Flag: Philippines": "๐ต๐ญ", "Flag: St. Martin": "๐ฒ๐ซ", "Flag: Mexico": "๐ฒ๐ฝ", "Flag: Anguilla": "๐ฆ๐ฎ", "Flag: Bhutan": "๐ง๐น", "Flag: Bangladesh": "๐ง๐ฉ", "Flag: Clipperton Island": "๐จ๐ต", "Flag: Nicaragua": "๐ณ๐ฎ", "Flag: Egypt": "๐ช๐ฌ", "Flag: Gabon": "๐ฌ๐ฆ", "Flag: Cameroon": "๐จ๐ฒ", "Flag: Caribbean Netherlands": "๐ง๐ถ", "Flag: Cรดte dโIvoire": "๐จ๐ฎ", "Flag: Bolivia": "๐ง๐ด", "Flag: Comoros": "๐ฐ๐ฒ", "Flag: Ireland": "๐ฎ๐ช", "Flag: Croatia": "๐ญ๐ท", "Flag: Dominica": "๐ฉ๐ฒ", "Flag: Ethiopia": "๐ช๐น", "Flag: Lesotho": "๐ฑ๐ธ", "Flag: Guernsey": "๐ฌ๐ฌ", "Flag: Bouvet Island": "๐ง๐ป", "Flag: Thailand": "๐น๐ญ", "Flag: U.S. Outlying Islands": "๐บ๐ฒ", "Flag: รland Islands": "๐ฆ๐ฝ", "Flag: England": "๐ด๓ ง๓ ข๓ ฅ๓ ฎ๓ ง๓ ฟ", "Flag: Mauritania": "๐ฒ๐ท", "Flag: South Georgia & South Sandwich Islands": "๐ฌ๐ธ", "Flag: Northern Mariana Islands": "๐ฒ๐ต", "Flag: Greenland": "๐ฌ๐ฑ", "Flag: Greece": "๐ฌ๐ท", "Flag: Macao Sar China": "๐ฒ๐ด", "Flag: Vietnam": "๐ป๐ณ", "Flag: Georgia": "๐ฌ๐ช"]
    
     var all = [String]()
}
