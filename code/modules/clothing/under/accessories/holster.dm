/obj/item/clothing/accessory/storage/holster
	name = "shoulder holster"
	desc = "A handgun holster."
	icon_state = "holster"
	slots = 1
	max_w_class = ITEM_SIZE_NORMAL
	var/list/can_holster = null
	var/sound_in = 'sound/effects/holster/holsterin.ogg'
	var/sound_out = 'sound/effects/holster/holsterout.ogg'

/obj/item/clothing/accessory/storage/holster/Initialize()
	. = ..()
	set_extension(src, /datum/extension/holster, /datum/extension/holster, hold, sound_in, sound_out, can_holster)

/obj/item/clothing/accessory/storage/holster/attackby(obj/item/W as obj, mob/user as mob)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	if(H.holster(W, user))
		return
	else
		. = ..(W, user)

	if(sound_in)
		playsound(get_turf(src), sound_in, 50)
	if(istype(user))
		user.stop_aiming(no_message=1)
	holstered = I
	user.drop_from_inventory(holstered)
	holstered.loc = src
	holstered.add_fingerprint(user)
	w_class = max(w_class, holstered.w_class)
	user.visible_message("<span class='notice'>[user] holsters \the [holstered].</span>", "<span class='notice'>You holster \the [holstered].</span>")
	name = "occupied [initial(name)]"

/obj/item/clothing/accessory/holster/proc/clear_holster()
	holstered = null
	SetName(initial(name))

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return
	else
		var/sound_vol = 25
		if(user.a_intent == I_HURT)
			sound_vol = 50
			usr.visible_message(
				"<span class='danger'>[user] draws \the [holstered], ready to go!</span>",
				"<span class='warning'>You draw \the [holstered], ready to go!</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>[user] draws \the [holstered], pointing it at the ground.</span>",
				"<span class='notice'>You draw \the [holstered], pointing it at the ground.</span>"
				)
		if(sound_out)
			playsound(get_turf(src), sound_out, sound_vol)
		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		w_class = initial(w_class)
		clear_holster()

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob)
	holster(W, user)

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit)
		unholster(user)
	else
		..()

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/storage/holster/examine(mob/user)
	. = ..(user)
	var/datum/extension/holster/H = get_extension(src, /datum/extension/holster)
	H.examine_holster(user)

/obj/item/clothing/accessory/storage/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /atom/proc/holster_verb

/obj/item/clothing/accessory/storage/holster/on_removed(mob/user as mob)
	if(has_suit)
		var/remove_verb = TRUE
		if(has_extension(has_suit, /datum/extension/holster))
			remove_verb = FALSE

		for(var/obj/accessory in has_suit.accessories)
			if(accessory == src)
				continue
			if(has_extension(accessory, /datum/extension/holster))
				remove_verb = FALSE

		if(remove_verb)
			has_suit.verbs -= /atom/proc/holster_verb
	..()

/obj/item/clothing/accessory/storage/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry."
	icon_state = "holster"

/obj/item/clothing/accessory/storage/holster/waist
	name = "waist holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	overlay_state = "holster_low"

/obj/item/clothing/accessory/storage/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_hip"

/obj/item/clothing/accessory/storage/holster/thigh
	name = "thigh holster"
	desc = "A drop leg holster made of a durable synthetic fiber."
	icon_state = "holster_thigh"
	sound_in = 'sound/effects/holster/tactiholsterin.ogg'
	sound_out = 'sound/effects/holster/tactiholsterout.ogg'

/obj/item/clothing/accessory/storage/holster/machete
	name = "machete sheath"
	desc = "A handsome synthetic leather sheath with matching belt."
	icon_state = "holster_machete"
	can_hold = list(/obj/item/weapon/material/hatchet/machete)
