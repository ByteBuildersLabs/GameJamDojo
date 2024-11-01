use dojo_starter::models::Beast;

#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn decrease_stats(ref self: T);
    fn feed(ref self: T);
    fn sleep(ref self: T);
    fn play(ref self: T);
    fn clean(ref self: T);
}

#[dojo::contract]
pub mod actions {
    use super::{IActions};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Beast};

    use dojo::model::{ModelStorage, ModelValueStorage};
    use dojo::event::EventStorage;


    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");

            let player = get_caller_address();

            let initial_stats = Beast {
                player: player,
                life: 10,
                max_life: 10,
                hungry: 10,
                max_hungry: 10,
                energy: 10,
                max_energy: 10,
                happiness: 10,
                max_happiness: 10,
                bath: 10,
                max_bath: 10,
                level: 1,
                experience: 0,
                next_level_experience: 10,
            };

            world.write_model(@initial_stats);

        }

         fn decrease_stats(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.hungry = beast.hungry - 5;
                beast.energy = beast.energy - 3;
                beast.happiness = beast.happiness - 2;
                beast.bath = beast.bath - 2;

                if beast.hungry == 0 || beast.energy == 0 || beast.happiness == 0 || beast.bath == 0 {
                    beast.life = beast.life - 5;
                }

                world.write_model(@beast);
            }
        }

        fn feed(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.hungry =  beast.hungry + 30;
                beast.energy = beast.energy + 10;
                world.write_model(@beast);
            }
        }

        fn sleep(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.energy = beast.energy + 40;
                beast.happiness = beast.happiness + 10;
                world.write_model(@beast);
            }
        }

        fn play(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.happiness = beast.happiness + 30;
                beast.energy = beast.energy - 20;
                beast.hungry = beast.hungry - 10;
                beast.experience += 10;

                if beast.experience >= beast.next_level_experience {
                    beast.level += 1;
                    beast.experience = 0;
                    beast.next_level_experience += 100;
                }

                world.write_model(@beast);
            }
        }

        fn clean(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.bath = beast.bath + 40;
                beast.happiness = beast.happiness + 10;
                world.write_model(@beast);
            }
        }

    }
}

