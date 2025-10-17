Changelog between 15.12 and 16.04:

Router Registers
	- Router Input VC Status (RIVCS)
		*updated description
	- Router Event Counter Control (RECC)
		*updated description
	- Router Event Counter (REC)
		*typo fix
	- Router ID (RID)
		*updated description
		
Streaming Bridge registers
	- Bridge Transmit Event Counter Control (T)
		*typo fix
	- Bridge Receive FIFO Status (BRS)
		*updated description
	- Bridge Tx Upsizer Status (BTUS)
		*updated description
	- Receive Interrupt Mask (RXEM)
		*typo fix
		
AXI Master Registers
	- Slave Address Relocation Register (AM_ADRELOCSLV)
		*new register
	- System Address Relocation Register (AM_ADRELOCSYS)
		*new register
	- Address Relocation Register (AM_ADRELOC)
		*removed (replaces by AM_ADRELOCSLV and AM_ADRELOCSYS)
	- Timeout Configuration Register (AM_TOCFG)
		*updated description
	- Status and Error Register (AM_ERR)
		*updated description
	- Interrupt Mask Register (AM_INTM)
		*updated description
	- Coherency Connect Request Register (AM_SYSCOREQ)
	- Coherency Connect Request Status Register (AM_SYSCOACK)
	- Hash Function Registers (AM_HASH_FUNC)
		*new registers
	- Command Capture Control Register (AM_CCMD0)
		*updated description
	- Command Capture Control Register (AM_CCMD1)
		*updated description

APB Registers
	- Bridge Version Register (APBSLV_BRIDGE_VERSION)
	- Bridge ID Register (APBSLV_BRIDGE_ID)
	- Slave Sleep Status Register (APBSLV_SLVS_SLEEP_STATUS)
		*new registers
	