# Vyper 0.3.10
# https://proofivy.com

event PublicCommit:
    sender: indexed(address)
    hash: String[64]
    public_commit_count: uint256

event PublicMessage:
    sender: indexed(address)
    message: String[333]
    public_message_count: uint256

event SignedPublicCommit:
    sender: indexed(address)
    hash: String[64]
    signed_public_commit_count: uint256
    signature: Bytes[65]

event SignedPublicMessage:
    sender: indexed(address)
    message: String[333]
    signed_public_message_count: uint256
    signature: Bytes[65]

event FoundGuild:
    guild: String[99]

event AddGuildAdmin:
    guild: String[99]
    admin: indexed(address)

event RemoveGuildAdmin:
    guild: String[99]
    admin: indexed(address)

event AspireGuildMembership:
    guild: String[99]

event RemoveAspiringGuildMembership:
    guild: String[99]

event AddGuildMember:
    guild: String[99]
    member: indexed(address)

event RemoveGuildMember:
    guild: String[99]
    member: indexed(address)

event GuildCommit:
    guild: String[99]
    sender: indexed(address)
    hash: String[64]
    guild_commit_count: uint256

event GuildMessage:
    guild: String[99]
    sender: indexed(address)
    message: String[333]
    guild_message_count: uint256

event SignedGuildCommit:
    guild: String[99]
    sender: indexed(address)
    hash: String[64]
    signed_guild_commit_count: uint256
    signature: Bytes[65]

event SignedGuildMessage:
    guild: String[99]
    sender: indexed(address)
    message: String[333]
    signed_guild_message_count: uint256
    signature: Bytes[65]

contract_owner: address

public_commit_price: public(uint256)
public_message_price: public(uint256)

public_commit_counter: public(uint256)
public_commit_senders: public(HashMap[uint256, address])
public_commits: public(HashMap[uint256, String[64]])

public_message_counter: public(uint256)
public_message_senders: public(HashMap[uint256, address])
public_messages: public(HashMap[uint256, String[333]])

signed_public_commit_counter: public(uint256)
signed_public_commit_senders: public(HashMap[uint256, address])
signed_public_commits: public(HashMap[uint256, String[64]])
signed_public_commit_signatures: public(HashMap[uint256, Bytes[65]])

signed_public_message_counter: public(uint256)
signed_public_message_senders: public(HashMap[uint256, address])
signed_public_messages: public(HashMap[uint256, String[333]])
signed_public_message_signatures: public(HashMap[uint256, Bytes[65]])

guilds: public(HashMap[String[99], bool])
guild_admins: public(HashMap[String[99], HashMap[address, bool]])
guild_aspiring_members: public(HashMap[String[99], HashMap[address, bool]])
guild_members: public(HashMap[String[99], HashMap[address, bool]])

guild_commit_counter: public(HashMap[String[99], uint256])
guild_commit_senders: public(HashMap[String[99], HashMap[uint256, address]])
guild_commits: public(HashMap[String[99], HashMap[uint256, String[64]]])

guild_message_counter: public(HashMap[String[99], uint256])
guild_message_senders: public(HashMap[String[99], HashMap[uint256, address]])
guild_messages: public(HashMap[String[99], HashMap[uint256, String[333]]])

signed_guild_commit_counter: public(HashMap[String[99], uint256])
signed_guild_commit_senders: public(HashMap[String[99], HashMap[uint256, address]])
signed_guild_commits: public(HashMap[String[99], HashMap[uint256, String[64]]])
signed_guild_commit_signatures: public(HashMap[String[99], HashMap[uint256, Bytes[65]]])

signed_guild_message_counter: public(HashMap[String[99], uint256])
signed_guild_message_senders: public(HashMap[String[99], HashMap[uint256, address]])
signed_guild_messages: public(HashMap[String[99], HashMap[uint256, String[333]]])
signed_guild_message_signatures: public(HashMap[String[99], HashMap[uint256, Bytes[65]]])


@external
def __init__():
    self.contract_owner = msg.sender
    self.public_commit_price = 1_000_000_000_000_000
    self.public_message_price = 2_000_000_000_000_000


@external
def change_owner(_contract_owner: address):
    assert msg.sender == self.contract_owner, 'You must own the contract'
    self.contract_owner = _contract_owner


@external
def set_public_commit_price(_commit_price: uint256):
    assert msg.sender == self.contract_owner, 'You must own the contract'
    self.public_commit_price = _commit_price


@external
def set_public_message_price(_message_price: uint256):
    assert msg.sender == self.contract_owner, 'You must own the contract'
    self.public_message_price = _message_price


@external
@payable
def public_commit(hash: String[64]):
    assert msg.value >= self.public_commit_price, 'Insufficient funds'
    raw_call(self.contract_owner, b"", value=msg.value)
    self.public_commit_counter += 1
    self.public_commit_senders[self.public_commit_counter] = msg.sender
    self.public_commits[self.public_commit_counter] = hash
    log PublicCommit(msg.sender, hash, self.public_commit_counter)


@external
@payable
def public_message(message: String[333]):
    assert msg.value >= self.public_message_price, 'Insufficient funds'
    raw_call(self.contract_owner, b"", value=msg.value)
    self.public_message_counter += 1
    self.public_message_senders[self.public_message_counter] = msg.sender
    self.public_messages[self.public_message_counter] = message
    log PublicMessage(msg.sender, message, self.public_message_counter)


@external
@payable
def signed_public_commit(hash: String[64], signature: Bytes[65]):
    assert msg.value >= self.public_commit_price, 'Insufficient funds'
    raw_call(self.contract_owner, b"", value=msg.value)
    self.signed_public_commit_counter += 1
    self.signed_public_commit_senders[self.signed_public_commit_counter] = msg.sender
    self.signed_public_commits[self.signed_public_commit_counter] = hash
    self.signed_public_commit_signatures[self.signed_public_commit_counter] = signature
    log SignedPublicCommit(msg.sender, hash, self.signed_public_commit_counter, signature)


@external
@payable
def signed_public_message(message: String[333], signature: Bytes[65]):
    assert msg.value >= self.public_message_price, 'Insufficient funds'
    raw_call(self.contract_owner, b"", value=msg.value)
    self.signed_public_message_counter += 1
    self.signed_public_message_senders[self.signed_public_message_counter] = msg.sender
    self.signed_public_messages[self.signed_public_message_counter] = message
    self.signed_public_message_signatures[self.signed_public_message_counter] = signature
    log SignedPublicMessage(msg.sender, message, self.signed_public_message_counter, signature)


@external
def found_guild(guild: String[99], first_admin: address):
    assert msg.sender == self.contract_owner, 'You must own the contract'
    assert not self.guilds[guild], 'Guild name already in use'
    self.guilds[guild] = True
    self.guild_admins[guild][first_admin] = True
    self.guild_members[guild][first_admin] = True
    log FoundGuild(guild)
    log AddGuildAdmin(guild, first_admin)
    log AddGuildMember(guild, first_admin)


@external
def add_guild_admin(guild: String[99], admin: address):
    assert msg.sender == self.contract_owner, 'You must own the contract'
    self.guild_admins[guild][admin] = True
    log AddGuildAdmin(guild, admin)


@external
def remove_guild_admin(guild: String[99], admin: address):
    assert msg.sender == self.contract_owner, 'You must own the contract'
    self.guild_admins[guild][admin] = False
    log RemoveGuildAdmin(guild, admin)


@external
def aspire_guild_membership(guild: String[99]):
    assert self.guilds[guild], 'Guild does not exist'
    self.guild_aspiring_members[guild][msg.sender] = True
    log AspireGuildMembership(guild)


@external
def remove_aspiring_guild_membership(guild: String[99]):
    assert self.guilds[guild], 'Guild does not exist'
    self.guild_aspiring_members[guild][msg.sender] = False
    log RemoveAspiringGuildMembership(guild)


@external
def add_guild_member(guild: String[99], member: address):
    assert self.guild_admins[guild][msg.sender], 'Not an admin'
    assert self.guild_aspiring_members[guild][member], 'New member should first be an aspiring member'
    self.guild_members[guild][member] = True
    log AddGuildMember(guild, member)


@external
def remove_guild_member(guild: String[99], member: address):
    assert self.guild_admins[guild][msg.sender], 'Not an admin'
    self.guild_members[guild][member] = False
    log RemoveGuildMember(guild, member)


@external
def guild_commit(guild: String[99], hash: String[64]):
    assert self.guild_members[guild][msg.sender], 'Not a member'
    self.guild_commit_counter[guild] += 1
    self.guild_commit_senders[guild][self.guild_commit_counter[guild]] = msg.sender
    self.guild_commits[guild][self.guild_commit_counter[guild]] = hash
    log GuildCommit(guild, msg.sender, hash, self.guild_commit_counter[guild])


@external
def guild_message(guild: String[99], message: String[333]):
    assert self.guild_members[guild][msg.sender], 'Not a member'
    self.guild_message_counter[guild] += 1
    self.guild_message_senders[guild][self.guild_message_counter[guild]] = msg.sender
    self.guild_messages[guild][self.guild_message_counter[guild]] = message
    log GuildMessage(guild, msg.sender, message, self.guild_message_counter[guild])


@external
def signed_guild_commit(guild: String[99], hash: String[64], signature: Bytes[65]):
    assert self.guild_members[guild][msg.sender], 'Not a member'
    self.signed_guild_commit_counter[guild] += 1
    self.signed_guild_commit_senders[guild][self.signed_guild_commit_counter[guild]] = msg.sender
    self.signed_guild_commits[guild][self.signed_guild_commit_counter[guild]] = hash
    self.signed_guild_commit_signatures[guild][self.signed_guild_commit_counter[guild]] = signature
    log SignedGuildCommit(guild, msg.sender, hash, self.signed_guild_commit_counter[guild], signature)


@external
def signed_guild_message(guild: String[99], message: String[333], signature: Bytes[65]):
    assert self.guild_members[guild][msg.sender], 'Not a member'
    self.signed_guild_message_counter[guild] += 1
    self.signed_guild_message_senders[guild][self.signed_guild_message_counter[guild]] = msg.sender
    self.signed_guild_messages[guild][self.signed_guild_message_counter[guild]] = message
    self.signed_guild_message_signatures[guild][self.signed_guild_message_counter[guild]] = signature
    log SignedGuildMessage(guild, msg.sender, message, self.signed_guild_message_counter[guild], signature)
