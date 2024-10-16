use core::starknet::{ContractAddress, contract_address_const};
use snforge_std::{declare, ContractClassTrait, DeclareResultTrait};

// use testing_smart_contracts::simple_contract::{
//     ISimpleContractDispatcher, ISimpleContractDispatcherTrait
// };
use x_clone::{ 
    IXCloneDispatcher,
    IXCloneDispatcherTrait,
 };


fn deploy_x_clone() -> (ContractAddress, IXCloneDispatcher) {
    let contract = declare("XClone").unwrap().contract_class();
    let owner = contract_address_const::<'owner'>();

    let mut constructor_calldata = array![
        owner.into()
    ];

    let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

    let dispatcher = IXCloneDispatcher { contract_address };

    (contract_address, dispatcher)
}

#[test]
fn test_deploy() {
    let (_, dispatcher) = deploy_x_clone();

    let new_post:ByteArray = "Hello this is a new post";
    dispatcher.create_post(new_post);

    let post = dispatcher.get_post();

    //  assert!(post.content == "Hello this is a new post", 'Should deploy the contract and create a post');
    // assert_eq!(post.content == "Hello this is a new post", 'Should deploy the contract and create a post');
}





// fn deploy_pizza_factory() -> (IPizzaFactoryDispatcher, ContractAddress) {
//     let contract = declare("PizzaFactory").unwrap();
//     let owner: ContractAddress = contract_address_const::<'owner'>();

//     let mut constructor_calldata = array![owner.into()];

//     let (contract_address, _) = contract.deploy(@constructor_calldata).unwrap();

//     let dispatcher = IPizzaFactoryDispatcher { contract_address };

//     (dispatcher, contract_address)
// }