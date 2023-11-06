<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Charges>
 */
class ChargesFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    private $guest_house=1;
    public function definition(): array
    {
        return [
            'room_type'=>(['AC','NON-AC'])[random_int(0,1)],
            'booking_type'=>(['OFFICIAL','PERSONAL'])[random_int(0,1)],
            'charge'=>random_int(300,400),
            'guest_house_id'=>($this->guest_house++)%2
        ];
    }
}
