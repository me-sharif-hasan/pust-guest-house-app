<?php

namespace Database\Factories;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\AllocationRequest>
 */
class AllocationRequestFactory extends Factory
{
    /**
     *
    $table->id();
    $table->unsignedBigInteger('user_id');
    $table->unsignedBigInteger('guest_house_id');
    $table->unsignedBigInteger('room_id')->nullable();
    $table->string('bed_number')->nullable();
    $table->integer('guest_count')->default(1);
    $table->string('room_type');
$table->string('booking_type');
$table->string('status')->nullable();
$table->string('boarder_type')->nullable();
$table->text("behalf_of")->nullable();
$table->longText("rejection_reason")->nullable();
$table->longText("cancellation_reason")->nullable();
$table->string("allocation_purpose")->default("night_stay");
$table->dateTime("boarding_date");
$table->dateTime("departure_date");
$table->dateTime('extension_request_date')->nullable();
$table->boolean('is_admin_seen')->default(false);
$table->boolean('is_user_seen')->default(false);
$table->string('token')->unique()->index()->nullable();
     */
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $date=Carbon::now()->addDays(random_int(0,365));
        return [
            'allocation_purpose'=>(['Day Stay Only','Night Stay'])[random_int(0,1)],
            'user_id'=>random_int(1,3),
            'guest_house_id'=>random_int(1,2),
            'status'=>(['pending'])[random_int(0,0)],
            'room_type'=>(['AC','NON-AC'])[random_int(0,1)],
            'boarder_type'=>(['female','male','family'])[random_int(0,2)],
            'behalf_of'=>(['[{"name":"My Self"}]','[{"name":"আজিজুল হক, বাবা\nশামিমা বেগম, মা\nabcd, wife"}]'])[random_int(0,1)],
            'booking_type'=>(['PERSONAL','OFFICIAL'])[random_int(0,1)],
            'guest_count'=>random_int(1,5),
            'boarding_date'=>$date,
            'departure_date'=>fake()->dateTimeBetween($date, $date->format('Y-m-d H:i:s').' +365 days'),
            'token'=>uniqid(time())
        ];
    }
}
