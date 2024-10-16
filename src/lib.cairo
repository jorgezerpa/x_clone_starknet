use core::starknet::{ContractAddress };

#[derive(Clone, Drop, Serde, starknet::Store)]
pub struct Post {
    id: u256,
    pub autor: ContractAddress,
    pub content: ByteArray,
    pub timestamp: u64,
}

#[starknet::interface]
pub trait IXClone<TContractState> {
    fn create_post(ref self:TContractState, post:ByteArray);
    fn get_post(self:@TContractState) -> Post;
    fn get_posts(self:@TContractState);
}

#[starknet::contract]
mod XClone {
    use super::Post;
    use core::starknet::{ContractAddress, get_caller_address, get_block_timestamp };
    use starknet::storage::{ StoragePointerReadAccess, StoragePointerWriteAccess, StoragePathEntry, Map };
    // use use starknet::

    #[storage]
    struct Storage {
        owner:ContractAddress,
        posts: Map<ContractAddress, Post>,
    }

    #[constructor]
    fn constructor(ref self: ContractState, _owner: ContractAddress) {
        self.owner.write(_owner);
    }   


    #[abi(embed_v0)]
    impl XClone of super::IXClone<ContractState>{
        fn create_post(ref self:ContractState, post:ByteArray){
            let new_post: Post = Post {
                id:0,
                autor: get_caller_address(),
                content: post,
                timestamp: get_block_timestamp(),
            };
            self.posts.write(get_caller_address(), new_post)
        }
        
        fn get_post(self:@ContractState) -> Post {
            self.posts.read(get_caller_address())
        }

        fn get_posts(self:@ContractState){}
    }


}


// #[starknet::interface]
// pub trait IHelloStarknet<TContractState> {
//     fn increase_balance(ref self: TContractState, amount: felt252);
//     fn get_balance(self: @TContractState) -> felt252;
// }

// #[starknet::contract]
// mod HelloStarknet {
//     #[storage]
//     struct Storage {
//         balance: felt252, 
//     }

//     #[abi(embed_v0)]
//     impl HelloStarknetImpl of super::IHelloStarknet<ContractState> {
//         fn increase_balance(ref self: ContractState, amount: felt252) {
//             assert(amount != 0, 'Amount cannot be 0');
//             self.balance.write(self.balance.read() + amount);
//         }

//         fn get_balance(self: @ContractState) -> felt252 {
//             self.balance.read()
//         }
//     }
// }
