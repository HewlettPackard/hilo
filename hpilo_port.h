
#define PCI_DEVICE_SUB(_vendor, _device, _subvendor, _subdevice)	\
	.vendor = (_vendor), .device = (_device),			\
	.subvendor = (_subvendor), .subdevice = (_subdevice)

#define PCI_VENDOR_ID_HP_3PAR		0x1590
#define PCI_VENDOR_ID_COMPAQ            0x0e11
#define PCI_REVISION_ID           0x08    /* Revision ID */

#define EPOLLIN			POLLIN		/* x01 */
#define EPOLLERR		POLLERR		/* x08 */
#define EPOLLRDNORM		POLLRDNORM	/* x40 */

#define MODULE_ALIAS(x)

#define MATCH(_id, _dev, _idfld, _devfld) \
	(_id->_idfld == PCI_ANY_ID || _id->_idfld == _dev->_devfld)

static int
pci_match_id(const struct pci_device_id *ids, struct pci_dev *dev)
{
	for (; ids->vendor; ids++) {
		if (MATCH(ids, dev, vendor, vendor) &&
		    MATCH(ids, dev, device, device) &&
		    MATCH(ids, dev, subvendor, subsystem_vendor) &&
		    MATCH(ids, dev, subdevice, subsystem_device))
			return 1;
	}
	return 0;
}

static inline void *
hpilo_pci_iomap(struct pci_dev *dev, int mmio_bar, int mmio_size __unused)
{
	unsigned long addr, len;

	addr = pci_resource_start(dev, mmio_bar);
	len = pci_resource_len(dev, mmio_bar);
	if (!addr)
		return NULL;

	return ioremap(addr, len);
}

static inline void
hpilo_pci_iounmap(struct pci_dev *dev, void *res)
{
	iounmap(res);
}

static inline void *
pci_iomap_range(struct pci_dev *dev, int bar, unsigned long offset,
		unsigned long maxlen)
{
	void *vaddr;

	vaddr = hpilo_pci_iomap(dev, bar, maxlen);
	if (vaddr)
		vaddr = (caddr_t)vaddr + offset;
	return vaddr;
}

static inline int
hpilo_make_dev(struct make_dev_args *args, struct cdev *ptr, char *name)
{
#pragma push_macro("cdev")
#undef cdev
	return make_dev_s(args, &ptr->cdev, "%s", name);
#pragma pop_macro("cdev")
}

MODULE_DEPEND(hpilo, linuxkpi, 1, 1, 1);
