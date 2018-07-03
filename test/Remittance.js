const Remittance = artifacts.require("Remittance");


contract('Remittance', async(accounts) => {
 let owner = accounts[0];
 let Carol = accounts[1];
 let Thief = accounts[1];
 let instance;
 let oneTimePassword = "0x9daca";
 let oneTimePassword_2 = "0x9dadd";

    beforeEach('setup contract for each test', async () => {
        instance = await Remittance.new({ from: owner});
    });


    it('should have an owner', async () => {
        assert.equal(await instance.owner(), owner);
    });

 
    it('should accept remittances from owner', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      let remittee = await instance.Remittees(hash);
      assert.equal(remittee[0], 1e+18);
    });


    it('should not accept remittances from anyone other than owner', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      let err = null
      try {
            await instance.sendRemittance(hash, {from: Carol, value: 1e+18});
        } catch (error) {
       err = error;
      }
    assert.ok(err instanceof Error);
    });


    it('should not let me reuse my old password', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      let err = null
      try {
            await instance.sendRemittance(hash, {from: owner, value: 1e+18});
          } catch (error) {
       err = error;
      }
    assert.ok(err instanceof Error);
    });


    it('should let Carol withdraw on providing the right password', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      await instance.withdraw(oneTimePassword, {from: Carol});
      let remittee = await instance.Remittees(hash);
      assert.equal(remittee[0], 0);
    });


    it('should not let anyone withdraw on providing the wrong password', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      try {
           await instance.withdraw("0xaaa", {from: Carol});
         } catch (error) {
       err = error;
      }
    assert.ok(err instanceof Error);
    });


    it('should not let anyone other than Carol withdraw on providing the right password', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      try {
           await instance.withdraw(oneTimePassword, {from: Thief});
         } catch (error) {
       err = error;
      }
    assert.ok(err instanceof Error);
    });


    it('should let owner pause/resume the contract', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      await instance.pause({from: owner});
      try {
           let hashNew = await instance.hashHelper(oneTimePassword_2, Carol);
           await instance.sendRemittance(hashNew, {from: owner, value: 1e+18});
         } catch (error) {
       err = error;
      }
     assert.ok(err instanceof Error);
     await instance.resume({from: owner});
     let hash_2 = await instance.hashHelper(oneTimePassword_2, Carol);
     await instance.sendRemittance(hash_2, {from: owner, value: 1e+18});
     let remittee = await instance.Remittees(hash_2);
     assert.equal(remittee[0], 1e+18);
    });


   it('should not let anyone other than owner to pause/resume the contract', async () => {
      let hash = await instance.hashHelper(oneTimePassword, Carol);
      await instance.sendRemittance(hash, {from: owner, value: 1e+18});
      try {
            await instance.pause({from: owner});
         } catch (error) {
       err = error;
      }
     assert.ok(err instanceof Error);
    });



})

