<?php

namespace App\Filament\Resources\CustomerInventoryResource\Pages;

use App\Filament\Resources\CustomerInventoryResource;
use Filament\Pages\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateCustomerInventory extends CreateRecord
{
    protected static string $resource = CustomerInventoryResource::class;
}
