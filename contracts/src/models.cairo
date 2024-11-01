use starknet::ContractAddress;

#[derive(Drop, Serde, Debug)]
#[dojo::model]
pub struct Beast {
    #[key]
    pub player: ContractAddress,
    pub life: u32,
    pub max_life: u32,
    pub hungry: u32,
    pub max_hungry: u32,
    pub energy: u32,
    pub max_energy: u32,
    pub happiness: u32,
    pub max_happiness: u32,
    pub bath: u32,
    pub max_bath: u32,
    pub level: u32,
    pub experience: u32,
    pub next_level_experience: u32,
}

