use dojo_starter::models::Beast;

// define the interface
#[starknet::interface]
trait IActions<T> {
    fn spawn(ref self: T);
    fn feed(ref self: T);
    fn sleep(ref self: T);
    fn play(ref self: T);
    fn clean(ref self: T);
}

// dojo decorator
#[dojo::contract]
pub mod actions {
    use super::{IActions};
    use starknet::{ContractAddress, get_caller_address};
    use dojo_starter::models::{Beast};

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {
        fn spawn(ref self: ContractState) {
            let initial_stats = Beast {
                player: get_caller_address(),
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
            self.world(@"dojo_starter").write_model(@initial_stats);
        }

        // Disminuye las estadísticas automáticamente
        fn decrease_stats(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.hungry = u32::max(0, beast.hungry - 2);
                beast.energy = u32::max(0, beast.energy - 1);
                beast.happiness = u32::max(0, beast.happiness - 1);
                beast.bath = u32::max(0, beast.bath - 1);

                if beast.hungry == 0
                    || beast.energy == 0
                    || beast.happiness == 0
                    || beast.bath == 0 {
                    beast.life = u32::max(0, beast.life - 5);
                }

                world.write_model(@beast);
            }
        }

        // Alimentar
        fn feed(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.hungry = u32::min(beast.max_hungry, beast.hungry + 30);
                beast.energy = u32::min(beast.max_energy, beast.energy + 10);
                world.write_model(@beast);
            }
        }

        // Dormir
        fn sleep(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.energy = u32::min(beast.max_energy, beast.energy + 40);
                beast.happiness = u32::min(beast.max_happiness, beast.happiness + 10);
                world.write_model(@beast);
            }
        }

        // Jugar
        fn play(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.happiness = u32::min(beast.max_happiness, beast.happiness + 30);
                beast.energy = u32::max(0, beast.energy - 20);
                beast.hungry = u32::max(0, beast.hungry - 10);
                beast.experience += 10;

                // Subir de nivel si la experiencia excede el límite
                if beast.experience >= beast.next_level_experience {
                    beast.level += 1;
                    beast.experience = 0;
                    beast.next_level_experience += 100;
                }

                world.write_model(@beast);
            }
        }

        // Limpiar
        fn clean(ref self: ContractState) {
            let mut world = self.world(@"dojo_starter");
            let player = get_caller_address();
            let mut beast: Beast = world.read_model(player);

            if beast.life > 0 {
                beast.bath = u32::min(beast.max_bath, beast.bath + 40);
                beast.happiness = u32::min(beast.max_happiness, beast.happiness + 10);
                world.write_model(@beast);
            }
        }
    }
}
